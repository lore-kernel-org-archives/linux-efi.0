From: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [edk2] Corrupted EFI region
Date: Mon, 05 Aug 2013 23:55:55 +0200
Message-ID: <52001F6B.4000800@redhat.com>
References: <20130801164927.GA7445@pd.tnic> <51FF8C14.2070405@redhat.com> <20130805130258.GB31845@pd.tnic> <51FFAB13.4090603@redhat.com> <20130805140306.GD31845@pd.tnic> <51FFB660.4060400@redhat.com> <20130805144010.GE31845@pd.tnic> <2DBE3EA4-E321-4A7B-B9AF-EDE55BC2E358@apple.com> <20130805181225.GH31845@pd.tnic> <52001B04.2050806@zytor.com> <20130805214140.GB14067@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130805214140.GB14067-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Fish <afish-2kanFRK1NckAvxtiuMwx3w@public.gmane.org>, edk2-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gleb Natapov <gleb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 08/05/13 23:41, Borislav Petkov wrote:
> On Mon, Aug 05, 2013 at 02:37:08PM -0700, H. Peter Anvin wrote:
>> All of this would be a non-problem if there weren't buggy
>> implementations which can't run *without* SetVirtualAddressMap().
> 
> Oh, you mean, if we were to call the runtime services through their
> physical addresses?

I heard that there was a (U)EFI firmware implementation that didn't even
implement SetVirtualAddressMap(). It was okay because the main OS for
that platform didn't want to call it, it thunked to physical mode for
each runtime service call.

(This is not hearsay; I'm omitting the specifics because I'm not sure if
I'm allowed to give any. I've heard about this stuff from a direct
colleague who used to work on these systems.)

Laszlo
