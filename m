From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Random crashes with i386 and efi boots
Date: Tue, 11 Sep 2018 07:59:10 -1000
Message-ID: <CA+55aFzZ2rBWPrYOSozf44HNDhPPm94GCnsVDwCtnTOJbvombQ@mail.gmail.com>
References: <20180910215659.GA17966@roeck-us.net> <D213F8BC-5C8E-44A2-810F-918B915F0804@amacapital.net>
 <877118e5-beee-4551-28d3-79e7aa52f74e@roeck-us.net> <90A7FF2E-F186-49CF-A028-CDE317BE13E1@amacapital.net>
 <20180911174158.7qu6f4vfnfzqqrcf@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180911174158.7qu6f4vfnfzqqrcf@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Joerg Roedel <jroedel@suse.de>
Cc: Andy Lutomirski <luto@amacapital.net>, Guenter Roeck <linux@roeck-us.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Michal Hocko <mhocko@suse.com>, Andi Kleen <ak@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>, Pavel Machek <pavel@ucw.cz>, linux-efi <linux-efi@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Sep 11, 2018 at 7:42 AM Joerg Roedel <jroedel@suse.de> wrote:
>
> So I am in favor of changing the order in efi_call_phys_epilog() too.

Yeah, the only reason the order was changed was that it seemed more
logical to use the new cr3 to load the GDT. But that was clearly
wrong.

So ack on just changing the order, and my bad for suggesting the
change in the first place.

            Linus
