From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi: add conditional include of asm/early_ioremap.h
Date: Mon, 11 Jan 2016 21:15:20 +0100
Message-ID: <CAKv+Gu8MMU1D3O7=2xfouSSyw_VMX22SFL4PAnwJ4Mr-Ag2N_g@mail.gmail.com>
References: <1452456249-2974-1-git-send-email-ard.biesheuvel@linaro.org>
	<20160111144004.GD2644@codeblueprint.co.uk>
	<3908561D78D1C84285E8C5FCA982C28F39FA9F4B@ORSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F39FA9F4B-8oqHQFITsIE64kNsxIetb7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org" <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "Yu, Fenghua" <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 11 January 2016 at 20:54, Luck, Tony <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On Sun, 10 Jan, at 09:04:09PM, Ard Biesheuvel wrote:
>> The code in efi.c uses early_memremap(), but relies on a transitive
>> include rather than including asm/early_ioremap.h directly.
>> Unfortunately, this header does not exist on ia64, so it cannot be
>> included directly.
>
> I wouldn't be adverse to you making an asm/early_ioremap.h file
> for ia64
>

How about an asm/efi.h? A lot of the EFI source files include both
linux/efi.h and asm/efi.h, so it would make sense to have one on ia64
as well
