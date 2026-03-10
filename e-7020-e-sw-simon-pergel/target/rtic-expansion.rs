#[doc = r" The RTIC application module"] pub mod app
{
    #[doc =
    r" Always include the device crate which contains the vector table"] use
    pac as you_must_enable_the_rt_feature_for_the_pac_in_your_cargo_toml; pub
    use rtic :: Monotonic as _;
    #[doc = r" Holds static methods for each monotonic."] pub mod monotonics
    {
        pub use MyMono :: now;
        #[doc =
        "This module holds the static implementation for `MyMono::now()`"]
        #[allow(non_snake_case)] pub mod MyMono
        {
            #[doc = r" Read the current time from this monotonic"] pub fn
            now() -> < super :: super :: MyMono as rtic :: Monotonic > ::
            Instant
            {
                rtic :: export :: interrupt ::
                free(| _ |
                {
                    use rtic :: Monotonic as _; if let Some(m) = unsafe
                    {
                        & mut * super :: super ::
                        __rtic_internal_MONOTONIC_STORAGE_MyMono.get_mut()
                    } { m.now() } else
                    {
                        < super :: super :: MyMono as rtic :: Monotonic > :: zero()
                    }
                })
            }
        }
    } use super :: * ; use cortex_m :: asm; use embedded_hal :: digital ::
    { OutputPin, StatefulOutputPin }; use hal ::
    {
        gpio :: p0 :: Parts as P0Parts, gpio ::
        { p0 :: P0_03, Input, Level, Output, Pin, PushPull }, monotonic ::
        MonotonicTimer,
    }; use nrf52840_hal ::
    { gpio :: Disconnected, pac :: saadc :: resolution, saadc }; use pac ::
    {
        saadc ::
        {
            ch :: config :: * , oversample :: OVERSAMPLE_A, resolution ::
            VAL_A
        }, TIMER0,
    }; use rtt_target :: { rprintln, rtt_init_print };
    #[doc = r" User code from within the module"] type MyMono = MonotonicTimer
    < TIMER0, 16_000_000 > ; #[doc = r" User code end"]
    #[doc = " User provided init function"] #[inline(always)]
    #[allow(non_snake_case)] fn init(cx : init :: Context) ->
    (Shared, Local, init :: Monotonics)
    {
        rtt_init_print! (); rprintln! ("\n--- Hello e7020e ---\n"); let mono =
        MyMono :: new(cx.device.TIMER0); let gpios = P0Parts ::
        new(cx.device.P0); let led =
        gpios.p0_13.into_push_pull_output(Level :: High).degrade(); let saadc
        = cx.device.SAADC; saadc.enable.write(| w | w.enable().enabled());
        saadc.resolution.write(| w | w.val().variant(VAL_A :: _14BIT));
        saadc.oversample.write(| w |
        w.oversample().variant(OVERSAMPLE_A :: BYPASS));
        saadc.samplerate.write(| w | w.mode().task()); saadc.ch
        [0].config.write(| w |
        {
            w.refsel().variant(REFSEL_A :: INTERNAL);
            w.gain().variant(GAIN_A :: GAIN4);
            w.tacq().variant(TACQ_A :: _20US);
            w.mode().variant(MODE_A :: DIFF);
            w.resp().variant(RESP_A :: BYPASS);
            w.resn().variant(RESN_A :: BYPASS); w.burst().disabled(); w
        }); saadc.ch [0].pselp.write(| w | w.pselp().analog_input1());
        saadc.ch [0].pseln.write(| w | w.pseln().analog_input2());
        saadc.events_calibratedone.reset();
        saadc.tasks_calibrateoffset.write(| w | unsafe { w.bits(1) }); while
        saadc.events_calibratedone.read().bits() == 0 {} rprintln!
        ("calibrated"); let mut delay = cortex_m :: delay :: Delay ::
        new(cx.core.SYST, 64_000_000); loop
        {
            let mut val : i16 = 0;
            saadc.result.ptr.write(| w | unsafe
            { w.ptr().bits(((& mut val) as * mut _) as u32) });
            saadc.result.maxcnt.write(| w | unsafe { w.maxcnt().bits(1) });
            core :: sync :: atomic ::
            compiler_fence(core :: sync :: atomic :: Ordering :: SeqCst);
            saadc.tasks_start.write(| w | unsafe { w.bits(1) });
            saadc.tasks_sample.write(| w | unsafe { w.bits(1) }); let mut c =
            0; while saadc.events_end.read().bits() == 0 { c += 1; }
            saadc.events_end.reset(); core :: sync :: atomic ::
            compiler_fence(core :: sync :: atomic :: Ordering :: SeqCst);
            rprintln! ("c {} val {}", c, val); delay.delay_us(500);
        } (Shared {}, Local {}, init :: Monotonics(mono))
    } #[doc = " User provided idle function"] #[allow(non_snake_case)] fn
    idle(_ : idle :: Context) -> !
    {
        use rtic :: Mutex as _; use rtic :: mutex :: prelude :: * ; loop
        { asm :: wfe(); }
    } #[doc = " RTIC shared resource struct"] struct Shared {}
    #[doc = " RTIC local resource struct"] struct Local {}
    #[doc = r" Monotonics used by the system"] #[allow(non_snake_case)]
    #[allow(non_camel_case_types)] pub struct
    __rtic_internal_Monotonics(pub MonotonicTimer < TIMER0, 16_000_000 >);
    #[doc = r" Execution context"] #[allow(non_snake_case)]
    #[allow(non_camel_case_types)] pub struct __rtic_internal_init_Context <
    'a >
    {
        #[doc = r" Core (Cortex-M) peripherals"] pub core : rtic :: export ::
        Peripherals, #[doc = r" Device peripherals"] pub device : pac ::
        Peripherals, #[doc = r" Critical section token for init"] pub cs :
        rtic :: export :: CriticalSection < 'a > ,
    } impl < 'a > __rtic_internal_init_Context < 'a >
    {
        #[doc(hidden)] #[inline(always)] pub unsafe fn
        new(core : rtic :: export :: Peripherals,) -> Self
        {
            __rtic_internal_init_Context
            {
                device : pac :: Peripherals :: steal(), cs : rtic :: export ::
                CriticalSection :: new(), core,
            }
        }
    } #[allow(non_snake_case)] #[doc = " Initialization function"] pub mod
    init
    {
        #[doc(inline)] pub use super :: __rtic_internal_Monotonics as
        Monotonics; #[doc(inline)] pub use super ::
        __rtic_internal_init_Context as Context;
    } #[doc = r" Execution context"] #[allow(non_snake_case)]
    #[allow(non_camel_case_types)] pub struct __rtic_internal_idle_Context < >
    {} impl < > __rtic_internal_idle_Context < >
    {
        #[doc(hidden)] #[inline(always)] pub unsafe fn
        new(priority : & rtic :: export :: Priority) -> Self
        { __rtic_internal_idle_Context {} }
    } #[allow(non_snake_case)] #[doc = " Idle loop"] pub mod idle
    {
        #[doc(inline)] pub use super :: __rtic_internal_idle_Context as
        Context;
    } #[doc = r" App module"] #[doc(hidden)] #[allow(non_upper_case_globals)]
    const __rtic_internal_MASK_CHUNKS : usize = rtic :: export ::
    compute_mask_chunks([]); #[doc(hidden)] #[allow(non_upper_case_globals)]
    const __rtic_internal_MASKS :
    [rtic :: export :: Mask < __rtic_internal_MASK_CHUNKS > ; 3] =
    [rtic :: export :: create_mask([]), rtic :: export :: create_mask([]),
    rtic :: export :: create_mask([])]; #[doc(hidden)]
    #[allow(non_camel_case_types)] #[allow(non_upper_case_globals)] static
    __rtic_internal_TIMER_QUEUE_MARKER : rtic :: RacyCell < u32 > = rtic ::
    RacyCell :: new(0); #[doc(hidden)] #[allow(non_camel_case_types)]
    #[derive(Clone, Copy)] pub enum SCHED_T {} #[doc(hidden)]
    #[allow(non_camel_case_types)] #[allow(non_upper_case_globals)] static
    __rtic_internal_TQ_MyMono : rtic :: RacyCell < rtic :: export ::
    TimerQueue < MonotonicTimer < TIMER0, 16_000_000 > , SCHED_T, 0 > > = rtic
    :: RacyCell ::
    new(rtic :: export ::
    TimerQueue(rtic :: export :: SortedLinkedList :: new_u16()));
    #[doc(hidden)] #[allow(non_camel_case_types)]
    #[allow(non_upper_case_globals)] static
    __rtic_internal_MONOTONIC_STORAGE_MyMono : rtic :: RacyCell < Option <
    MonotonicTimer < TIMER0, 16_000_000 > >> = rtic :: RacyCell :: new(None);
    #[no_mangle] #[allow(non_snake_case)] unsafe fn TIMER0()
    {
        while let Some((task, index)) = rtic :: export :: interrupt ::
        free(| _ | if let Some(mono) =
        (& mut * __rtic_internal_MONOTONIC_STORAGE_MyMono.get_mut()).as_mut()
        {
            (& mut *
            __rtic_internal_TQ_MyMono.get_mut()).dequeue(|| rtic :: export ::
            NVIC ::
            mask(you_must_enable_the_rt_feature_for_the_pac_in_your_cargo_toml
            :: interrupt :: TIMER0), mono)
        } else { core :: hint :: unreachable_unchecked() }) { match task {} }
        rtic :: export :: interrupt ::
        free(| _ | if let Some(mono) =
        (& mut * __rtic_internal_MONOTONIC_STORAGE_MyMono.get_mut()).as_mut()
        { mono.on_interrupt(); });
    } #[doc(hidden)] mod rtic_ext
    {
        use super :: * ; #[no_mangle] unsafe extern "C" fn main() -> !
        {
            rtic :: export :: assert_monotonic :: < MonotonicTimer < TIMER0,
            16_000_000 > > (); const _CONST_CHECK : () =
            { if ! rtic :: export :: have_basepri() {} else {} }; let _ =
            _CONST_CHECK; rtic :: export :: interrupt :: disable(); let mut
            core : rtic :: export :: Peripherals = rtic :: export ::
            Peripherals :: steal().into(); let _ =
            you_must_enable_the_rt_feature_for_the_pac_in_your_cargo_toml ::
            interrupt :: UARTE1; const _ : () = if
            (1 << pac :: NVIC_PRIO_BITS) < (1 << pac :: NVIC_PRIO_BITS) as
            usize
            {
                :: core :: panic!
                ("Maximum priority used by monotonic 'MyMono' is more than supported by hardware");
            };
            core.NVIC.set_priority(you_must_enable_the_rt_feature_for_the_pac_in_your_cargo_toml
            :: interrupt :: TIMER0, rtic :: export ::
            logical2hw((1 << pac :: NVIC_PRIO_BITS), pac :: NVIC_PRIO_BITS),);
            if ! < MonotonicTimer < TIMER0, 16_000_000 > as rtic :: Monotonic
            > :: DISABLE_INTERRUPT_ON_EMPTY_QUEUE
            {
                rtic :: export :: NVIC ::
                unmask(you_must_enable_the_rt_feature_for_the_pac_in_your_cargo_toml
                :: interrupt :: TIMER0);
            } #[inline(never)] fn __rtic_init_resources < F > (f : F) where F
            : FnOnce() { f(); }
            __rtic_init_resources(||
            {
                let (shared_resources, local_resources, mut monotonics) =
                init(init :: Context :: new(core.into()));
                monotonics.0.reset();
                __rtic_internal_MONOTONIC_STORAGE_MyMono.get_mut().write(Some(monotonics.0));
                rtic :: export :: interrupt :: enable();
            });
            idle(idle :: Context ::
            new(& rtic :: export :: Priority :: new(0)))
        }
    }
}