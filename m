From: Roy Franz <roy.franz@linaro.org>
Subject: Re: [PATCH] Add efi_early_call() macro
Date: Wed, 26 Mar 2014 10:40:31 -0700
Message-ID: <CAFECyb_YNCM2Yz3j4_pPcCLqk6u6NjKqEFzy48LfWk+b08barQ@mail.gmail.com>
References: <20140322110515.GF2815@console-pimps.org>
	<1395787231-14298-1-git-send-email-roy.franz@linaro.org>
	<20140326085953.GA2958@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140326085953.GA2958@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Matt Fleming <matt.fleming@intel.com>, Leif Lindholm <leif.lindholm@linaro.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg59@srcf.ucam.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Mar 26, 2014 at 1:59 AM, Matt Fleming <matt@console-pimps.org> wrote:
> On Tue, 25 Mar, at 03:40:30PM, Roy Franz wrote:
>> Add the efi_early_call() macro to invoke functions in the efi_early
>> structure. Using a macro for these invocations allows the arm32/arm64
>> architectures to define the macro differently so that they can directly
>> invoke the boot services functions that are exposed in the efi_early
>> structure on x86. Prior to the introduction of the efi_early structure
>> the efi_call_physN macros were used on all architectures and allowed
>> for this differentiation.
>>
>> Signed-off-by: Roy Franz <roy.franz@linaro.org>
>> ---
>>  arch/x86/boot/compressed/eboot.c       |    5 +++++
>>  drivers/firmware/efi/efi-stub-helper.c |   26 +++++++++++++-------------
>>  2 files changed, 18 insertions(+), 13 deletions(-)
>
> Confused.
>
> Why have you rewritten the patch that I sent Satuday morning?
>
>   https://lkml.org/lkml/2014/3/22/61
>
> I don't think your version goes far enough because you've left all the
> efi_early->call() stuff in eboot.c. So now there's two ways to invoke
> EFI functions in the x86 boot stub.
>
> What's wrong with the patch that I sent?
>
> --
> Matt Fleming, Intel Open Source Technology Center

Hi Matt,

   Sorry for the confusion - your patch is fine.  I had somehow not noticed
it on your reply.

Roy
