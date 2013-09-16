From: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [edk2] Corrupted EFI region
Date: Mon, 16 Sep 2013 18:25:22 +0200
Message-ID: <523730F2.40408@redhat.com>
References: <20130806141036.GD14891@pd.tnic> <520116D1.2010000@redhat.com> <20130807151935.GJ17920@pd.tnic> <CCFD3CBD-62B0-4046-B96D-18CB1A815F72@apple.com> <20130807201908.GG2515@console-pimps.org> <D5982201-6DC4-469F-812A-74A8402ADEE9@apple.com> <20130808101730.GJ2515@console-pimps.org> <20130913203812.GA312@anatevka.fc.hp.com> <20130916105920.GB2697@console-pimps.org> <5236F096.8040702@redhat.com> <20130916155751.GA3636@leaf>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130916155751.GA3636@leaf>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, jerry.hoemann-VXdhtT5mjnY@public.gmane.org, Andrew Fish <afish-2kanFRK1NckAvxtiuMwx3w@public.gmane.org>, edk2-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gleb Natapov <gleb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Brian Richardson <brian.richardson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Randy Wright <rwright-VXdhtT5mjnY@public.gmane.org>, Linn Crosetto <linn.crosetto-VXdhtT5mjnY@public.gmane.org>, terry.lee-VXdhtT5mjnY@public.gmane.org, samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org, randy.pawell-VXdhtT5mjnY@public.gmane.org, chrisp-VXdhtT5mjnY@public.gmane.org, linda.knippers-VXdhtT5mjnY@public.gmane.org, dong.wei-VXdhtT5mjnY@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Chao Zhang <chao.b.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yao Jiewen <jiewen.yao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 09/16/13 17:57, Josh Triplett wrote:

>> The edk2 commit that flipped the memory type underneath the image data
>> from EfiReservedMemoryType to EfiBootServicesData is:
>>
>>     https://github.com/tianocore/edk2/commit/4c58575e
>>
>> I think this commit is wrong. It's fine for OSPM to release the image
>> data at some point, but not right after ExitBootServices(), because
>> referencing pointers in ACPI tables survive strictly longer.
>>
>> ... Actually, the commit does follow the ACPI spec 5.0:
>>
>> 5.2.22.4 Image Address
>>
>>     The Image Address contains the location in memory where an
>>     in-memory copy of the boot image can be found. The image should be
>>     stored in EfiBootServicesData, allowing the system to reclaim
>>     the memory when the image is no longer needed.
>>
>> The ACPI spec 5.0 should recommend EfiACPIReclaimMemory here IMO. (I
>> take the current wording ("should be stored") as a recommendation only.)
> 
> I agree that UEFI *should* store the BGRT in EfiACPIReclaimMemory, but
> in practice the UEFI firmware I've seen with a BGRT does follow that
> recommendation and store it in EfiBootServicesData.  So, even if the
> recommendation in the spec changed, the kernel would still have to
> accomodate both possibilities.

Just for the theoretical debate:

The edk2 commit linked above is 5 days old. All UEFI firmware in the
wild (on released hardware) should be using EfiReservedMemoryType (the
pre-patch memory type), which is even stricter.

EfiReservedMemoryType can never be released & repurposed, so it should
make no difference for crash kernel allocation, shouldn't it?

- call efi_free_boot_services() -- doesn't touch the image data (which
  is in RAM of EfiReservedMemoryType),
- reserve crash kernel,
- access BGRT via ACPI.

BGRT had appeared in edk2 with

  https://github.com/tianocore/edk2/commit/0284e90c

and EfiReservedMemoryType used to be the allocation type until commit
4c58575e.

Or are you alluding to UEFI firmware that's not based on TianoCore?

Laszlo
