From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 2/2] efi: Add embedded peripheral firmware support
Date: Sat, 7 Apr 2018 13:13:31 +0200
Message-ID: <f5f6871c-ed41-fa43-3012-e01949686c2f@redhat.com>
References: <78ae4d18-8964-5748-a69f-0017d0dca5f7@redhat.com>
 <20180404171835.xvllgcqirl3b5gd5@redhat.com>
 <20180405054349.GA25653@wunner.de> <20180406140832.GF30543@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180406140832.GF30543@wotan.suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>, Lukas Wunner <lukas@wunner.de>
Cc: Peter Jones <pjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kalle Valo <kvalo@codeaurora.org>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, Dave Olsthoorn <dave@bewaar.me>, x86@kernel.org, linux-efi@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Matthew Garrett <mjg59@srcf.ucam.org>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds>
List-Id: linux-efi@vger.kernel.org

Hi,

On 06-04-18 16:08, Luis R. Rodriguez wrote:
> On Thu, Apr 05, 2018 at 07:43:49AM +0200, Lukas Wunner wrote:
>> On Wed, Apr 04, 2018 at 01:18:36PM -0400, Peter Jones wrote:
>>>> On Tue, Apr 03, 2018 at 08:07:11PM +0200, Lukas Wunner wrote:
>>>>> * Add the EFI Firmware Volume Protocol to include/linux/efi.h:
>>>>>    https://www.intel.com/content/dam/doc/reference-guide/efi-firmware-file-volume-specification.pdf
>>>>>
>>>>> * Amend arch/x86/boot/compressed/eboot.c to read the files with the
>>>>>    GUIDs you're interested in into memory and pass the files to the
>>>>>    kernel as setup_data payloads.
>>>
>>> To be honest, I'm a bit skeptical about the firmware volume approach.
>>> Tools like UEFITool[0] and uefi-firmware-parser[1] have existed for
>>> years, still don't seem to reliably parse firmware images I see in the
>>> wild, and have a fairly regular need for fixes.  These are tools
>>> maintained by smart people who are making a real effort, and it still
>>> looks pretty hard to do a good job that applies across a lot of
>>> platforms.
>>>
>>> So I'd rather use Hans's existing patches, at least for now, and if
>>> someone is interested in hacking on making an efi firmware volume parser
>>> for the kernel, switch them to that when such a thing is ready.
>>
>> Hello?  As I've written in the above-quoted e-mail the kernel should
>> read the files using EFI_FIRMWARE_VOLUME_PROTOCOL.ReadFile().
>>
>> *Not* by parsing the firmware volume!
>>
>> Parsing the firmware volume is only necessary to find out the GUIDs
>> of the files you're looking for.  You only do that *once*.
> 
> How do you get the GUIDs for each driver BTW?
> 
> Hans, I do believe we should *try* this approach at the very least.

Ok, so I've made a ROM dump of one of the tablets which I have with
the touchscreen firmware embedded in the EFI code using flashrom,
then I ran UEFIExtract on it, to get all the separate files.

Then I wrote a little test.sh script using hexdump piped to grep to
find the magic prefix, here is the result of running this on all
files UEFIExtract generated:

[hans@shalem chuwi-vi8-plus-cwi519-bios.bin.dump]$ find -type f -exec ./test.sh '{}' \;
0x00000c40        3136    B0 07 00 00 E4 07 00 00
found in ./2 BIOS region/6 8C8CE578-8A3D-4F1C-9935-896185C32DD3/31 I2cHid/1 EE4E5898-3914-4259-9D6E-DC7BD79403CF/0 PE32 image section/body.bin
0x00000be0        3040    B0 07 00 00 E4 07 00 00
found in ./2 BIOS region/5 8C8CE578-8A3D-4F1C-9935-896185C32DD3/31 I2cHid/1 EE4E5898-3914-4259-9D6E-DC7BD79403CF/0 PE32 image section/body.bin

With the version found at offset 0xbe0 of the "5 8C8CE578-8A3D-4F1C-9935-896185C32DD3"
section matching what we find in the efi_boot_services_code while running.

As the I2cHid name suggests this is embedded in the driver (which is a PE executable), not in a separate file:
[hans@shalem chuwi-vi8-plus-cwi519-bios.bin.dump]$ file './2 BIOS region/5 8C8CE578-8A3D-4F1C-9935-896185C32DD3/31 I2cHid/1 EE4E5898-3914-4259-9D6E-DC7BD79403CF/0 PE32 image section/body.bin'
./2 BIOS region/5 8C8CE578-8A3D-4F1C-9935-896185C32DD3/31 I2cHid/1 EE4E5898-3914-4259-9D6E-DC7BD79403CF/0 PE32 image section/body.bin: MS-DOS executable

So using the EFI_FIRMWARE_VOLUME_PROTOCOL.ReadFile() is not really
going to help here, since this is not in a separate file which we
can consume in its entirety, we still need to scan for the prefix
and do e.g. a CRC check to make sure we've actually got what we
expect, at which point simply scanning all of efi_boot_services_code
is a lot simpler and less error prone.

Using an implementation specific EFI protocol for this means calling
into EFI code and potentially triggering various bugs in there, breaking
boot. This is esp. likely to happen since this is a protocol which is
not used outside of the EFI ROMs internal code so there are likely
little ABI guarantees making this approach extra error prone.

Just scanning the efi_boot_services_code OTOH is quite safe TODO.

As for the overhead of scanning the efi_boot_services_code, we are
only doing this on a dmi match, so on most machines there is no
overhead other then the dmi check. On machines where there is
a dmi match, the price (I guess about 30 ms or so for the scan)
is well worth the result of having the touchscreen OOTB.

Regard,

Hans
