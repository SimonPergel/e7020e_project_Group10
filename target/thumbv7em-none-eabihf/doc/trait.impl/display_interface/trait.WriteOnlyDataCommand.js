(function() {
    var implementors = Object.fromEntries([["display_interface_i2c",[["impl&lt;I2C&gt; <a class=\"trait\" href=\"display_interface/trait.WriteOnlyDataCommand.html\" title=\"trait display_interface::WriteOnlyDataCommand\">WriteOnlyDataCommand</a> for <a class=\"struct\" href=\"display_interface_i2c/struct.I2CInterface.html\" title=\"struct display_interface_i2c::I2CInterface\">I2CInterface</a>&lt;I2C&gt;<div class=\"where\">where\n    I2C: <a class=\"trait\" href=\"embedded_hal/i2c/trait.I2c.html\" title=\"trait embedded_hal::i2c::I2c\">I2c</a>,</div>"]]],["display_interface_spi",[["impl&lt;SPI, DC&gt; <a class=\"trait\" href=\"display_interface/trait.WriteOnlyDataCommand.html\" title=\"trait display_interface::WriteOnlyDataCommand\">WriteOnlyDataCommand</a> for <a class=\"struct\" href=\"display_interface_spi/struct.SPIInterface.html\" title=\"struct display_interface_spi::SPIInterface\">SPIInterface</a>&lt;SPI, DC&gt;<div class=\"where\">where\n    SPI: <a class=\"trait\" href=\"embedded_hal/spi/trait.SpiDevice.html\" title=\"trait embedded_hal::spi::SpiDevice\">SpiDevice</a>,\n    DC: <a class=\"trait\" href=\"embedded_hal/digital/trait.OutputPin.html\" title=\"trait embedded_hal::digital::OutputPin\">OutputPin</a>,</div>"]]],["ssd1306",[]]]);
    if (window.register_implementors) {
        window.register_implementors(implementors);
    } else {
        window.pending_implementors = implementors;
    }
})()
//{"start":57,"fragment_lengths":[517,687,15]}