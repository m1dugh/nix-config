{ config, ... }:

{
# Enable CUPS to print documents.
    services.printing.enable = true;

    # Enables Bluetooth.
    services.blueman.enable = false;
}
