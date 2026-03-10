// rtic_interior_mut

#![no_main]
#![no_std]

use nrf52840_hal as _;
use panic_rtt_target as _;

#[rtic::app(device = nrf52840_hal::pac)]
mod app {

    use core::sync::atomic::*;
    use nrf52840_hal::pac::Interrupt;
    use rtt_target::{rprintln, rtt_init_print};

    #[shared]
    struct Shared {
        atomic_bool: AtomicBool, // atomic access allowing interior mut
    }

    #[local]
    struct Local {}

    #[init]
    fn init(_: init::Context) -> (Shared, Local, init::Monotonics) {
        rtt_init_print!();
        rprintln!("\n--- init ---\n");

        (
            Shared {
                atomic_bool: AtomicBool::new(false),
            },
            Local {},
            init::Monotonics(),
        )
    }

    #[idle(shared = [&atomic_bool])]
    fn idle(cx: idle::Context) -> ! {
        rprintln!("idle atomic_bool {:?}", cx.shared.atomic_bool);
        // Ordering relaxed should be sufficient only accesses
        // to the value of `atomic_bool` is synchronized
        cx.shared.atomic_bool.store(true, Ordering::Relaxed);
        rprintln!("idle atomic_bool {:?}", cx.shared.atomic_bool);

        rtic::pend(Interrupt::USBD);
        rprintln!("idle atomic_bool {:?}", cx.shared.atomic_bool);

        loop {}
    }

    // Task that that changes the &T value (interior mutability)
    #[task(binds=USBD, priority = 2, shared = [&atomic_bool])]
    fn t1(cx: t1::Context) {
        // rprintln!("t1, atomic_bool {:?}", cx.shared.atomic_bool);
        // mutate `atomic_bool` in the preempting task
        cx.shared.atomic_bool.store(false, Ordering::Relaxed);
    }
}

// This small example shows how we can do lock free access to shared resources
// from tasks with different priorities in case of interior mutable types.
//
// Idle runs at priority 0 and gets preempted by
// t1 running at priority 1
//
// Both tasks mutates the shared resource `atomic_bool`.
//
// The generated assembly:
// cargo objdump --example rtic_interior_mut  --release -- --disassemble > rtic_interior_mut.objdump
//
// 0000020a <USBD>:
// 20a: f240 4144    	movw	r1, #0x444  # low part of address to shared resource
// 20e: 2200         	movs	r2, #0x0    # false value (0)
// 210: f2c2 0100    	movt	r1, #0x2000 # high part of address to shared resource
// 214: f3ef 8011    	mrs	r0, basepri     # reading basepri
// 218: 700a         	strb	r2, [r1]    # lock free update
// 21a: f380 8811    	msr	basepri, r0     # restoring basepri
// 21e: 4770         	bx	lr
//
// Actually since the task never makes any lock the reading/writing of basepri could be optimized out
// (It was once implemented, but apparently never merged:)
