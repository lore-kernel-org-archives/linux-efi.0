From: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Subject: Re: [PATCH v8 0/2] Enable capsule loader interface for efi firmware
 updating
Date: Wed, 07 Oct 2015 15:59:30 +0100
Message-ID: <56153352.8020704@nexus-software.ie>
References: <1444245233-19229-1-git-send-email-hock.leong.kweh@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1444245233-19229-1-git-send-email-hock.leong.kweh@intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, Matt Fleming <matt@console-pimps.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ong Boon Leong <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Roy Franz <roy.franz@linaro.org>, Borislav Petkov <bp@alien8.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Fleming Matt <matt.fleming@intel.com>, h.peter.anvin@intel.com
List-Id: linux-efi@vger.kernel.org

On 07/10/15 20:13, Kweh, Hock Leong wrote:
> From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
>
> Dear maintainers & communities,
>
> This patchset is created on top of Matt's patchset:
> 1.)https://lkml.org/lkml/2014/10/7/390
> "[PATCH 1/2] efi: Move efi_status_to_err() to efi.h"
> 2.)https://lkml.org/lkml/2014/10/7/391
> "[PATCH 2/2] efi: Capsule update support"
>
> It expose a misc char interface for user to upload the capsule binary and
> calling efi_capsule_update() API to pass the binary to EFI firmware.
>
> The steps to update efi firmware are:
> 1.) cat firmware.cap > /dev/efi_capsule_loader
> 2.) reboot
>
> Any failed upload error message will be returned while doing "cat" through
> file operation write() function call.
>
> Tested the code with Intel Quark Galileo GEN1 platform.
>
> Thanks.
>
> ---
> NOTE:
> If Matt agrees with this design, [PATCH v7 1/1] will be squash into his
> [PATCH 2/2]: https://lkml.org/lkml/2014/10/7/391 for submitting.
>
> changelog v8:
> * further clean up on kunmap() & efi_free_all_buff_pages()
> * design enhanced to support 1st few writes are less than efi header size
> * removed support to padding capsule and flag error once the upload size
>    bigger than header defined size
>
> changelog v7:
> * add successful message printed in dmesg
> * shorten the code in efi_capsule_write() by splitting out
>    efi_capsule_setup_info() & efi_capsule_submit_update() functions
> * design added capability to support multiple file open action
> * re-write those comments by following standard format
> * design added the "uncomplete" error return through flush() file operation
>
> changelog v6:
> * clean up on error handling for better code flow and review
> * clean up on pr_err() for critical error only
> * design taking care writing block that below PAGE_SIZE
> * once error has occurred, design will return -EIO until file close
> * document design expectations/scenarios in the code
> * change the dynamic allocation cap_info struct to statically allocated
>
> changelog v5:
> * changed to new design without leveraging firmware_class API
> * use misc_char device interface instead of sysfs
> * error return through file Write() function call
>
>
> Kweh, Hock Leong (2):
>    efi: export efi_capsule_supported() function symbol
>    efi: a misc char interface for user to update efi firmware
>
>   drivers/firmware/efi/Kconfig              |   10
>   drivers/firmware/efi/Makefile             |    1
>   drivers/firmware/efi/capsule.c            |    1
>   drivers/firmware/efi/efi-capsule-loader.c |  356 +++++++++++++++++++++++++++++
>   4 files changed, 368 insertions(+)
>   create mode 100644 drivers/firmware/efi/efi-capsule-loader.c
>

Wilson.

Same question as at V7. If you aren't supporting the MFH on Galileo then 
what capsule are you using with 0.75 BIOS ? From memory it won't work 
without the MFH included ...

--
BOD

