#[doc = r" The RTIC application module"] pub mod app
{
    #[doc =
    r" Always include the device crate which contains the vector table"] use
    nrf52840_hal :: pac as
    you_must_enable_the_rt_feature_for_the_pac_in_your_cargo_toml; pub use
    rtic :: Monotonic as _;
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
    } use super :: * ; use usbd_serial :: embedded_io :: Write as _;
    #[doc = r" User code from within the module"] type MyMono = Systick <
    TIMER_HZ > ; #[doc = r" User code end"]
    #[doc = " User provided init function"] #[inline(always)]
    #[allow(non_snake_case)] fn init(cx : init :: Context) ->
    (Shared, Local, init :: Monotonics)
    {
        rtt_init_print! (); rprintln! ("\n--- init ---"); let mut mono =
        Systick :: new(cx.core.SYST, 64_000_000); let device = cx.device;
        device.USBD.intenset.write(| w | w.sof().set()); let clocks = Clocks
        :: new(device.CLOCK).enable_ext_hfosc();
        cx.local.clocks.replace(clocks.enable_ext_hfosc()); let usb_bus =
        UsbBusAllocator ::
        new(Usbd ::
        new(UsbPeripheral ::
        new(device.USBD, cx.local.clocks.as_ref().unwrap(),)));
        cx.local.usb_bus.replace(usb_bus); let port0 = P0Parts ::
        new(device.P0); let button =
        port0.p0_11.into_pullup_input().degrade(); let serial = SerialPort ::
        new(& cx.local.usb_bus.as_ref().unwrap()); let usb_dev =
        UsbDeviceBuilder ::
        new(& cx.local.usb_bus.as_ref().unwrap(),
        UsbVidPid(0x16c0,
        0x27dd)).strings(&
        [StringDescriptors ::
        default().manufacturer("Fake company").product("Serial port").serial_number("TEST")]).unwrap().device_class(USB_CLASS_CDC).max_packet_size_0(64).unwrap().build();
        #[allow(unreachable_code)]
        (Shared { unix_time : 0, }, Local
        { button, usb_dev, serial, buf : [0u8; 64] }, init ::
        Monotonics(mono))
    } #[doc = " User HW task: button"] #[allow(non_snake_case)] fn
    button(mut cx : button :: Context)
    { use rtic :: Mutex as _; use rtic :: mutex :: prelude :: * ; }
    #[doc = " User HW task: usb_interrupt"] #[allow(non_snake_case)] fn
    usb_interrupt(mut cx : usb_interrupt :: Context)
    { use rtic :: Mutex as _; use rtic :: mutex :: prelude :: * ; }
    #[doc = " RTIC shared resource struct"] struct Shared { unix_time : u64, }
    #[doc = " RTIC local resource struct"] struct Local
    {
        button : hal :: gpio :: Pin < hal :: gpio :: Input < hal :: gpio ::
        PullUp > > , usb_dev : usb_device :: device :: UsbDevice < 'static,
        Usbd < UsbPeripheral < 'static > > > , serial : SerialPort < 'static,
        Usbd < UsbPeripheral < 'static > > > , buf : [u8; 64],
    } #[allow(non_snake_case)] #[allow(non_camel_case_types)]
    #[doc = " Local resources `init` has access to"] pub struct
    __rtic_internal_initLocalResources < >
    {
        #[doc = " Local resource `usb_bus`"] pub usb_bus : & 'static mut
        Option < UsbBusAllocator < Usbd < UsbPeripheral < 'static > > > > ,
        #[doc = " Local resource `clocks`"] pub clocks : & 'static mut Option
        < Clocks < hal :: clocks :: ExternalOscillator, hal :: clocks ::
        Internal, hal :: clocks :: LfOscStopped > > ,
    } #[doc = r" Monotonics used by the system"] #[allow(non_snake_case)]
    #[allow(non_camel_case_types)] pub struct
    __rtic_internal_Monotonics(pub Systick < TIMER_HZ >);
    #[doc = r" Execution context"] #[allow(non_snake_case)]
    #[allow(non_camel_case_types)] pub struct __rtic_internal_init_Context <
    'a >
    {
        #[doc = r" Core (Cortex-M) peripherals"] pub core : rtic :: export ::
        Peripherals, #[doc = r" Device peripherals"] pub device : nrf52840_hal
        :: pac :: Peripherals, #[doc = r" Critical section token for init"]
        pub cs : rtic :: export :: CriticalSection < 'a > ,
        #[doc = r" Local Resources this task has access to"] pub local : init
        :: LocalResources < > ,
    } impl < 'a > __rtic_internal_init_Context < 'a >
    {
        #[doc(hidden)] #[inline(always)] pub unsafe fn
        new(core : rtic :: export :: Peripherals,) -> Self
        {
            __rtic_internal_init_Context
            {
                device : nrf52840_hal :: pac :: Peripherals :: steal(), cs :
                rtic :: export :: CriticalSection :: new(), core, local : init
                :: LocalResources :: new(),
            }
        }
    } #[allow(non_snake_case)] #[doc = " Initialization function"] pub mod
    init
    {
        #[doc(inline)] pub use super :: __rtic_internal_initLocalResources as
        LocalResources; #[doc(inline)] pub use super ::
        __rtic_internal_Monotonics as Monotonics; #[doc(inline)] pub use super
        :: __rtic_internal_init_Context as Context;
    } mod shared_resources
    {
        use rtic :: export :: Priority; #[doc(hidden)]
        #[allow(non_camel_case_types)] pub struct
        unix_time_that_needs_to_be_locked < 'a > { priority : & 'a Priority, }
        impl < 'a > unix_time_that_needs_to_be_locked < 'a >
        {
            #[inline(always)] pub unsafe fn new(priority : & 'a Priority) ->
            Self { unix_time_that_needs_to_be_locked { priority } }
            #[inline(always)] pub unsafe fn priority(& self) -> & Priority
            { self.priority }
        }
    } #[allow(non_snake_case)] #[allow(non_camel_case_types)]
    #[doc = " Shared resources `button` has access to"] pub struct
    __rtic_internal_buttonSharedResources < 'a >
    {
        #[doc =
        " Resource proxy resource `unix_time`. Use method `.lock()` to gain access"]
        pub unix_time : shared_resources :: unix_time_that_needs_to_be_locked
        < 'a > ,
    } #[doc = r" Execution context"] #[allow(non_snake_case)]
    #[allow(non_camel_case_types)] pub struct __rtic_internal_button_Context <
    'a >
    {
        #[doc = r" Shared Resources this task has access to"] pub shared :
        button :: SharedResources < 'a > ,
    } impl < 'a > __rtic_internal_button_Context < 'a >
    {
        #[doc(hidden)] #[inline(always)] pub unsafe fn
        new(priority : & 'a rtic :: export :: Priority) -> Self
        {
            __rtic_internal_button_Context
            { shared : button :: SharedResources :: new(priority), }
        }
    } #[allow(non_snake_case)] #[doc = " Hardware task"] pub mod button
    {
        #[doc(inline)] pub use super :: __rtic_internal_buttonSharedResources
        as SharedResources; #[doc(inline)] pub use super ::
        __rtic_internal_button_Context as Context;
    } #[allow(non_snake_case)] #[allow(non_camel_case_types)]
    #[doc = " Shared resources `usb_interrupt` has access to"] pub struct
    __rtic_internal_usb_interruptSharedResources < 'a >
    {
        #[doc =
        " Resource proxy resource `unix_time`. Use method `.lock()` to gain access"]
        pub unix_time : shared_resources :: unix_time_that_needs_to_be_locked
        < 'a > ,
    } #[doc = r" Execution context"] #[allow(non_snake_case)]
    #[allow(non_camel_case_types)] pub struct
    __rtic_internal_usb_interrupt_Context < 'a >
    {
        #[doc = r" Shared Resources this task has access to"] pub shared :
        usb_interrupt :: SharedResources < 'a > ,
    } impl < 'a > __rtic_internal_usb_interrupt_Context < 'a >
    {
        #[doc(hidden)] #[inline(always)] pub unsafe fn
        new(priority : & 'a rtic :: export :: Priority) -> Self
        {
            __rtic_internal_usb_interrupt_Context
            { shared : usb_interrupt :: SharedResources :: new(priority), }
        }
    } #[allow(non_snake_case)] #[doc = " Hardware task"] pub mod usb_interrupt
    {
        #[doc(inline)] pub use super ::
        __rtic_internal_usb_interruptSharedResources as SharedResources;
        #[doc(inline)] pub use super :: __rtic_internal_usb_interrupt_Context
        as Context;
    } #[doc = r" App module"] impl < > __rtic_internal_initLocalResources < >
    {
        #[inline(always)] #[doc(hidden)] pub unsafe fn new() -> Self
        {
            __rtic_internal_initLocalResources
            {
                usb_bus : & mut *
                __rtic_internal_local_init_usb_bus.get_mut(), clocks : & mut *
                __rtic_internal_local_init_clocks.get_mut(),
            }
        }
    } #[allow(non_camel_case_types)] #[allow(non_upper_case_globals)]
    #[doc(hidden)] #[link_section = ".uninit.rtic0"] static
    __rtic_internal_shared_resource_unix_time : rtic :: RacyCell < core :: mem
    :: MaybeUninit < u64 >> = rtic :: RacyCell ::
    new(core :: mem :: MaybeUninit :: uninit()); impl < 'a > rtic :: Mutex for
    shared_resources :: unix_time_that_needs_to_be_locked < 'a >
    {
        type T = u64; #[inline(always)] fn lock < RTIC_INTERNAL_R >
        (& mut self, f : impl FnOnce(& mut u64) -> RTIC_INTERNAL_R) ->
        RTIC_INTERNAL_R
        {
            #[doc = r" Priority ceiling"] const CEILING : u8 = 1u8; unsafe
            {
                rtic :: export ::
                lock(__rtic_internal_shared_resource_unix_time.get_mut() as *
                mut _, self.priority(), CEILING, nrf52840_hal :: pac ::
                NVIC_PRIO_BITS, & __rtic_internal_MASKS, f,)
            }
        }
    } #[doc(hidden)] #[allow(non_upper_case_globals)] const
    __rtic_internal_MASK_CHUNKS : usize = rtic :: export ::
    compute_mask_chunks([nrf52840_hal :: pac :: Interrupt :: GPIOTE as u32,
    nrf52840_hal :: pac :: Interrupt :: USBD as u32]); #[doc(hidden)]
    #[allow(non_upper_case_globals)] const __rtic_internal_MASKS :
    [rtic :: export :: Mask < __rtic_internal_MASK_CHUNKS > ; 3] =
    [rtic :: export ::
    create_mask([nrf52840_hal :: pac :: Interrupt :: GPIOTE as u32,
    nrf52840_hal :: pac :: Interrupt :: USBD as u32]), rtic :: export ::
    create_mask([]), rtic :: export :: create_mask([])];
    #[allow(non_camel_case_types)] #[allow(non_upper_case_globals)]
    #[doc(hidden)] #[link_section = ".uninit.rtic1"] static
    __rtic_internal_local_resource_button : rtic :: RacyCell < core :: mem ::
    MaybeUninit < hal :: gpio :: Pin < hal :: gpio :: Input < hal :: gpio ::
    PullUp > > >> = rtic :: RacyCell ::
    new(core :: mem :: MaybeUninit :: uninit());
    #[allow(non_camel_case_types)] #[allow(non_upper_case_globals)]
    #[doc(hidden)] #[link_section = ".uninit.rtic2"] static
    __rtic_internal_local_resource_usb_dev : rtic :: RacyCell < core :: mem ::
    MaybeUninit < usb_device :: device :: UsbDevice < 'static, Usbd <
    UsbPeripheral < 'static > > > >> = rtic :: RacyCell ::
    new(core :: mem :: MaybeUninit :: uninit());
    #[allow(non_camel_case_types)] #[allow(non_upper_case_globals)]
    #[doc(hidden)] #[link_section = ".uninit.rtic3"] static
    __rtic_internal_local_resource_serial : rtic :: RacyCell < core :: mem ::
    MaybeUninit < SerialPort < 'static, Usbd < UsbPeripheral < 'static > > >
    >> = rtic :: RacyCell :: new(core :: mem :: MaybeUninit :: uninit());
    #[allow(non_camel_case_types)] #[allow(non_upper_case_globals)]
    #[doc(hidden)] #[link_section = ".uninit.rtic4"] static
    __rtic_internal_local_resource_buf : rtic :: RacyCell < core :: mem ::
    MaybeUninit < [u8; 64] >> = rtic :: RacyCell ::
    new(core :: mem :: MaybeUninit :: uninit());
    #[allow(non_camel_case_types)] #[allow(non_upper_case_globals)]
    #[doc(hidden)] static __rtic_internal_local_init_usb_bus : rtic ::
    RacyCell < Option < UsbBusAllocator < Usbd < UsbPeripheral < 'static > > >
    > > = rtic :: RacyCell :: new(None); #[allow(non_camel_case_types)]
    #[allow(non_upper_case_globals)] #[doc(hidden)] static
    __rtic_internal_local_init_clocks : rtic :: RacyCell < Option < Clocks <
    hal :: clocks :: ExternalOscillator, hal :: clocks :: Internal, hal ::
    clocks :: LfOscStopped > > > = rtic :: RacyCell :: new(None);
    #[allow(non_snake_case)] #[no_mangle]
    #[doc = " User HW task ISR trampoline for button"] unsafe fn GPIOTE()
    {
        const PRIORITY : u8 = 1u8; rtic :: export ::
        run(PRIORITY, ||
        {
            button(button :: Context ::
            new(& rtic :: export :: Priority :: new(PRIORITY)))
        });
    } impl < 'a > __rtic_internal_buttonSharedResources < 'a >
    {
        #[doc(hidden)] #[inline(always)] pub unsafe fn
        new(priority : & 'a rtic :: export :: Priority) -> Self
        {
            __rtic_internal_buttonSharedResources
            {
                #[doc(hidden)] unix_time : shared_resources ::
                unix_time_that_needs_to_be_locked :: new(priority),
            }
        }
    } #[allow(non_snake_case)] #[no_mangle]
    #[doc = " User HW task ISR trampoline for usb_interrupt"] unsafe fn USBD()
    {
        const PRIORITY : u8 = 1u8; rtic :: export ::
        run(PRIORITY, ||
        {
            usb_interrupt(usb_interrupt :: Context ::
            new(& rtic :: export :: Priority :: new(PRIORITY)))
        });
    } impl < 'a > __rtic_internal_usb_interruptSharedResources < 'a >
    {
        #[doc(hidden)] #[inline(always)] pub unsafe fn
        new(priority : & 'a rtic :: export :: Priority) -> Self
        {
            __rtic_internal_usb_interruptSharedResources
            {
                #[doc(hidden)] unix_time : shared_resources ::
                unix_time_that_needs_to_be_locked :: new(priority),
            }
        }
    } #[doc(hidden)] #[allow(non_camel_case_types)]
    #[allow(non_upper_case_globals)] static __rtic_internal_TIMER_QUEUE_MARKER
    : rtic :: RacyCell < u32 > = rtic :: RacyCell :: new(0); #[doc(hidden)]
    #[allow(non_camel_case_types)] #[derive(Clone, Copy)] pub enum SCHED_T {}
    #[doc(hidden)] #[allow(non_camel_case_types)]
    #[allow(non_upper_case_globals)] static __rtic_internal_TQ_MyMono : rtic
    :: RacyCell < rtic :: export :: TimerQueue < Systick < TIMER_HZ > ,
    SCHED_T, 0 > > = rtic :: RacyCell ::
    new(rtic :: export ::
    TimerQueue(rtic :: export :: SortedLinkedList :: new_u16()));
    #[doc(hidden)] #[allow(non_camel_case_types)]
    #[allow(non_upper_case_globals)] static
    __rtic_internal_MONOTONIC_STORAGE_MyMono : rtic :: RacyCell < Option <
    Systick < TIMER_HZ > >> = rtic :: RacyCell :: new(None); #[no_mangle]
    #[allow(non_snake_case)] unsafe fn SysTick()
    {
        while let Some((task, index)) = rtic :: export :: interrupt ::
        free(| _ | if let Some(mono) =
        (& mut * __rtic_internal_MONOTONIC_STORAGE_MyMono.get_mut()).as_mut()
        {
            (& mut *
            __rtic_internal_TQ_MyMono.get_mut()).dequeue(|| core :: mem ::
            transmute :: < _, rtic :: export :: SYST >
            (()).disable_interrupt(), mono)
        } else { core :: hint :: unreachable_unchecked() }) { match task {} }
        rtic :: export :: interrupt ::
        free(| _ | if let Some(mono) =
        (& mut * __rtic_internal_MONOTONIC_STORAGE_MyMono.get_mut()).as_mut()
        { mono.on_interrupt(); });
    } #[doc(hidden)] mod rtic_ext
    {
        use super :: * ; #[no_mangle] unsafe extern "C" fn main() -> !
        {
            rtic :: export :: assert_send :: < u64 > (); rtic :: export ::
            assert_send :: < hal :: gpio :: Pin < hal :: gpio :: Input < hal
            :: gpio :: PullUp > > > (); rtic :: export :: assert_send :: <
            usb_device :: device :: UsbDevice < 'static, Usbd < UsbPeripheral
            < 'static > > > > (); rtic :: export :: assert_send :: <
            SerialPort < 'static, Usbd < UsbPeripheral < 'static > > > > ();
            rtic :: export :: assert_send :: < [u8; 64] > (); rtic :: export
            :: assert_monotonic :: < Systick < TIMER_HZ > > (); const
            _CONST_CHECK : () =
            {
                if ! rtic :: export :: have_basepri()
                {
                    if (nrf52840_hal :: pac :: Interrupt :: GPIOTE as usize) >=
                    (__rtic_internal_MASK_CHUNKS * 32)
                    {
                        :: core :: panic!
                        ("An interrupt out of range is used while in armv6 or armv8m.base");
                    } if (nrf52840_hal :: pac :: Interrupt :: USBD as usize) >=
                    (__rtic_internal_MASK_CHUNKS * 32)
                    {
                        :: core :: panic!
                        ("An interrupt out of range is used while in armv6 or armv8m.base");
                    }
                } else {}
            }; let _ = _CONST_CHECK; rtic :: export :: interrupt :: disable();
            let mut core : rtic :: export :: Peripherals = rtic :: export ::
            Peripherals :: steal().into(); let _ =
            you_must_enable_the_rt_feature_for_the_pac_in_your_cargo_toml ::
            interrupt :: SWI0_EGU0; const _ : () = if
            (1 << nrf52840_hal :: pac :: NVIC_PRIO_BITS) < 1u8 as usize
            {
                :: core :: panic!
                ("Maximum priority used by interrupt vector 'GPIOTE' is more than supported by hardware");
            };
            core.NVIC.set_priority(you_must_enable_the_rt_feature_for_the_pac_in_your_cargo_toml
            :: interrupt :: GPIOTE, rtic :: export ::
            logical2hw(1u8, nrf52840_hal :: pac :: NVIC_PRIO_BITS),); rtic ::
            export :: NVIC ::
            unmask(you_must_enable_the_rt_feature_for_the_pac_in_your_cargo_toml
            :: interrupt :: GPIOTE); const _ : () = if
            (1 << nrf52840_hal :: pac :: NVIC_PRIO_BITS) < 1u8 as usize
            {
                :: core :: panic!
                ("Maximum priority used by interrupt vector 'USBD' is more than supported by hardware");
            };
            core.NVIC.set_priority(you_must_enable_the_rt_feature_for_the_pac_in_your_cargo_toml
            :: interrupt :: USBD, rtic :: export ::
            logical2hw(1u8, nrf52840_hal :: pac :: NVIC_PRIO_BITS),); rtic ::
            export :: NVIC ::
            unmask(you_must_enable_the_rt_feature_for_the_pac_in_your_cargo_toml
            :: interrupt :: USBD); const _ : () = if
            (1 << nrf52840_hal :: pac :: NVIC_PRIO_BITS) <
            (1 << nrf52840_hal :: pac :: NVIC_PRIO_BITS) as usize
            {
                :: core :: panic!
                ("Maximum priority used by monotonic 'MyMono' is more than supported by hardware");
            };
            core.SCB.set_priority(rtic :: export :: SystemHandler :: SysTick,
            rtic :: export ::
            logical2hw((1 << nrf52840_hal :: pac :: NVIC_PRIO_BITS),
            nrf52840_hal :: pac :: NVIC_PRIO_BITS),); if ! < Systick <
            TIMER_HZ > as rtic :: Monotonic > ::
            DISABLE_INTERRUPT_ON_EMPTY_QUEUE
            {
                core :: mem :: transmute :: < _, rtic :: export :: SYST >
                (()).enable_interrupt();
            } #[inline(never)] fn __rtic_init_resources < F > (f : F) where F
            : FnOnce() { f(); }
            __rtic_init_resources(||
            {
                let (shared_resources, local_resources, mut monotonics) =
                init(init :: Context :: new(core.into()));
                __rtic_internal_shared_resource_unix_time.get_mut().write(core
                :: mem :: MaybeUninit :: new(shared_resources.unix_time));
                monotonics.0.reset();
                __rtic_internal_MONOTONIC_STORAGE_MyMono.get_mut().write(Some(monotonics.0));
                rtic :: export :: interrupt :: enable();
            }); loop { rtic :: export :: nop() }
        }
    }
}