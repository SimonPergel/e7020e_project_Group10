# rtic_bare9

What it covers:

- good design
- precise rtt tracing
  
---

## Background

In `rtic_bare8` you setup a serial communication parser and used that to control an application. This is a very common use-case.

You were using `rtt` to trace/debug your application.

We have only a single tracing channel, whereas RTIC tasks execute in a preemptive manner (thus your trace will be interleaved).

In cases this is what you want (to observe the preemptive behavior). However, traces becomes cluttered due to the interleaving.

One way to deal with this problem is to use several tracing channels as shown in the `rtic_bare9.rs`.

When running the application in `vscode` you will get 3 terminals `Idle`, `Log` and `Trace` each one associated to tasks running at different priorities, `Idle` at priority zero, `Log` at priority 1, and `Trace` at the highest priority 2. The naming of channels is completely up to you, so you can set them to reflect their purpose and intended use.

This split to priorities allows tasks running at the same priority to access the corresponding rtt channels as local (lock free resources).

In our example there is only a single task per priority, but this will work with arbitrary number of tasks at each priority.

In RTIC tasks are run-to-completion and tasks at the same priority will not preempt each other. Thus, one channel per priority ensures that the trace will be free of interleaving.

You can set the host side viewing behavior for each channel in the [launch.json](https://probe.rs/docs/tools/vscode/#configuring-rtt-to-transfer-data), e.g., you can enable host-side time stamping. Notice that will not give exact information to when the data was written (just when it was received).

Notice:
The tracing behavior might be dependent on the host poll rate, if your host is really slow you may run into `saturation` and potentially loose data. We will discuss how to address such problems in this exercise.

Disclaimer:
All examples are done on a fairly fast host. The principles still hold, it is not a show stopper if you don't get exactly the same results as me or your fellow student(s).

---

## Exercise 1

Run the example in vscode and give the input string "start" from `cutecom` (your terminal running on the host.) For this experiment we assume a host program to send all characters of the input as a chunk of data (not character by character as you type). This is to stress what happens in case a burst of data at 115.2 kbaud arrives. Higher baud rates allows for larger data throughput, with the drawback that accociated interruts arrive with shorter interval.

What did you receive in the `Idle` terminal?

```
idle
sleep
wake
sleep
wake
sleep
wake
sleep
```

Which task(s) did produce this output?

[` The task that did produce this output was the idle function`]

What did you receive in the `Log` terminal?

```
data_in 115
21:00:26.020: data_in 116
21:00:26.020: data_in 97
21:00:26.020: data_in 114
21:00:26.020: data_in 116
21:00:26.020: data_in 13
21:00:26.020: return [115, 116, 97, 114, 116], str Ok("start")
21:00:26.020: parse Some(Start), parse_result Ok(Start)
```

Which task(s) did produce this output?

[` From the code it was the data_in task`]

What did you receive in the `Trace` terminal?

```
uarte0 interrupt
21:00:26.029: Byte on serial0: 115
21:00:26.029: error WouldBlock
21:00:26.029: uarte0 interrupt
21:00:26.029: Byte on serial0: 116
21:00:26.029: error WouldBlock
21:00:26.029: uarte0 interrupt
```

Which task(s) did produce this output?

[` From the code i look like it was the uarte0_interrupt task`]

Commit your answers (bare9_1)

---

## Exercise 2

In `init` you find:

``` rust
let mut channels = rtt_init!(
    up: {
        0: {
            size: 128
            name:"Idle"
        }
        1: {
            size: 1024
            // mode: NoBlockTrim
            name:"Log"
        }
        2: {
            size: 128
            name:"Trace"
        }
    }
); 
```

For each channel we can set backing buffer size. (Recall that the host side debugger polls data stored in RAM on the target.)

In case the host does not keep up with the produced data, the buffer(s) will become depleted. You can set the saturating behavior by the [ChannelMode](https://docs.rs/rtt-target/0.3.1/rtt_target/enum.ChannelMode.html), where `NoBlockSkip` is the default. In this case any channel write that would saturate the buffer is skipped (and you will have data loss). 

Now reduce the buffer size for channel 1 (our `Log` buffer) to 128.

Re run the experiment, input "start" in `cutecom`:

What did you receive in the `Log` terminal?

```
data_in 115
21:19:05.610: data_in 116
21:19:05.610: data_in 97
21:19:05.610: data_in 114
21:19:05.610: data_in 116
21:19:05.610: data_in 13
21:19:05.610: return [115, 116, 97, 114, 116], str Ok("start")
```

Compare to previous exercise, how do the differ and what has happened here?

[`When the buffer size decreases to 128 bytes, the Log channel buffer fills up easier. Ones full new writes are silently skipped and this result in data loss`]

Now add `mode: NoBlockTrim` to channel 1.

What did you receive in the `Log` terminal?

```
data_in 115
23:26:02.304: data_in 116
23:26:02.304: data_in 97
23:26:02.304: data_in 114
23:26:02.304: data_in 116
23:26:02.304: data_in 13
23:26:02.304: return [115, 116, 97, 114, 116], str Ok("start")
23:26:02.304: parse So
```

What has happened here?

[` I guess you can say that the Log buffer filled up and old bytes were dropped, so the log line was truncated `]

Now change this to `mode: BlockIfFull` to channel 1.

What did you receive in the `Log` terminal?

```
23:35:56.445: data_in 116
23:35:56.445: data_in 97
23:35:56.445: data_in 114
23:35:56.445: data_in 116
23:35:56.445: data_in 13
23:35:56.445: return [115, 116, 97, 114, 116], str Ok("start")
me(Start), parse_result Ok(Start)

```

What has happened here?

[`When the buffer get full, the channel blocks data_in and then waits until there is space and then send it. More it seems that the first bytes has disapeared in the last line, this could happen if a kickstart read happens before the first real interup. This result in thta it will get consumed by this read and never reach the data_in task`]

Notice:
As mentioned the outcome is dependent on the host poll rate, so results might vary, principles the same though.

Commit your answers as (bare9_2)

---

## Learning Outcomes

A combination of tracing (e.g., using `rtt` trace) and debugging (using breakpoints, watches etc.) carries a long way to developing embedded applications. Without these tools, you would work completely in the blind.

Nevertheless, embedded programming is challenging facing the reality of complex tools and setups involving several systems interacting (host, debugger, target) over several protocols (Microsoft Debug Adopter Protocol between `vscode` and `probe-rs` host, `JLINK` between host and programmer, `SWD` between programmer and target, etc.)

The Rust ecosystem is built ground up to provide the best possible end-user experience, it is not (yet) perfect but on par or better than existing alternatives. We use it here cross platform, some of you on Linux (the native platform for most developers of the Rust ecosystem), but some of you are on OSX, others Windows (and that alone is a jungle of different possible setups, mingw, MSVC, Clang, MSBuild etc.), you can imagine the challenge and effort behind the Rust ecosystem.

At any rate, you have now learned how to take fine grained control over the tracing:

- mitigating interleaving by multiple `rtt` channels (one per priority)
- the effect of buffer sizes
- the effect of channel modes

When you later develop your own applications you can go back to this example to see what options that are at hand.

Disclaimer, the observed effects might vary dependent on system specifics. Some rules of thumb:

- To reduce the intrusive effects of RTT based tracing, use one channel per interrupt priority. This is especially important if tasks have short deadlines/inter-arrival times.

- If timing is of essence, use some non-blocking mode for RTT to ensure the tracing will not spin wait in case the buffer saturates (too slow host/too small buffer).

- If (trace) data is of essence (we cannot risk loosing trace data information), use blocking mode for RTT. 

- If both timing and data is of essence, use blocking RTT with large buffer.

