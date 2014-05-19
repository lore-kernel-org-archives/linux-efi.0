From: "Jan Beulich" <JBeulich-IBi9RG/b67k@public.gmane.org>
Subject: Re: [Xen-devel] [PATCH v4 3/5] xen: Put EFI machinery in place
Date: Mon, 19 May 2014 14:47:47 +0100
Message-ID: <537A27A30200007800013AD9@mail.emea.novell.com>
References: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com>
 <1400272904-31121-4-git-send-email-daniel.kiper@oracle.com>
 <537A0974.40302@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <537A0974.40302-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Cooper <andrew.cooper3-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Cc: david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org, jeremy-TSDbQ3PG+2Y@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, eshelton-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

>>> On 19.05.14 at 15:39, <andrew.cooper3-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org> wrote:
> On 16/05/14 21:41, Daniel Kiper wrote:
>> @@ -0,0 +1,374 @@
>> +/*
>> + * EFI support for Xen.
>> + *
>> + * Copyright (C) 1999 VA Linux Systems
>> + * Copyright (C) 1999 Walt Drummond <drummond-jCdQPDEk3idBDgjK7y7TUQ@public.gmane.org>
>> + * Copyright (C) 1999-2002 Hewlett-Packard Co.
>> + *	David Mosberger-Tang <davidm-sDzT885Ts8HQT0dZR+AlfA@public.gmane.org>
>> + *	Stephane Eranian <eranian-sDzT885Ts8HQT0dZR+AlfA@public.gmane.org>
>> + * Copyright (C) 2005-2008 Intel Co.
>> + *	Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> + *	Bibo Mao <bibo.mao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> + *	Chandramouli Narayanan <mouli-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>> + *	Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> + * Copyright (C) 2011 Novell Co.
>> + *	Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
>> + * Copyright (C) 2011-2012 Oracle Co.
>> + *	Liang Tang <liang.tang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> + * Copyright (c) 2014 Daniel Kiper, Oracle Corporation
>> + */
>> +
>> +#include <linux/bug.h>
>> +#include <linux/efi.h>
>> +#include <linux/init.h>
>> +#include <linux/string.h>
>> +
>> +#include <xen/interface/xen.h>
>> +#include <xen/interface/platform.h>
>> +
>> +#include <asm/xen/hypercall.h>
>> +
>> +#define call (op.u.efi_runtime_call)
> 
> I think not.

??? (Read: What's wrong with putting this shortcut in place?)

>> +#define DECLARE_CALL(what) \
>> +	struct xen_platform_op op; \
>> +	op.cmd = XENPF_efi_runtime_call; \
>> +	call.function = XEN_EFI_##what; \
>> +	call.misc = 0
> 
> Macros like this which explicitly create local variable with implicit
> names are evil when reading code.
> 
> If you want to do initialisation like this, then at least do something like:
> 
> #define INIT_EFI_CALL(what) \
> { .cmd = XENPF_efi_runtime_call, \
>    .u.efi_runtime_call.function = XEN_EFI_##what, \
>    .u.efi_runtime_call.misc = 0 }
> 
> And use it as:
> 
> struct xen_platform_op op = INIT_EFI_CALL(foo);

That's minimal redundancy as a goal versus (to you, but not to me)
legibility.

Jan
