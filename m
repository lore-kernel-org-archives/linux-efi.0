From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v11 3/5] x86/boot: Add get_acpi_rsdp() to parse RSDP in
 cmdlien from kexec
Date: Wed, 14 Nov 2018 19:33:15 +0100
Message-ID: <20181114183315.GJ13926@zn.tnic>
References: <20181112094645.4879-1-fanc.fnst@cn.fujitsu.com>
 <20181112094645.4879-4-fanc.fnst@cn.fujitsu.com>
 <20181113175150.GK10502@zn.tnic>
 <20181114015450.GA2875@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181114015450.GA2875@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Chao Fan <fanc.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, bhe@redhat.com, msys.mizuma@gmail.com, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Wed, Nov 14, 2018 at 09:54:50AM +0800, Chao Fan wrote:
> CONFIG_KEXEC is only needed in this function.
> 
> When searching RSDP, there are three methods in order:
> 1. When booting from KEXEC, 'acpi_rsdp' is added to cmdline by KEXEC,
>    so it can be parsed and used. CONFIG_KEXEC is needed here.

But theoretically acpi_rsdp can be supplied by the first kernel too,
right?

So you don't need that CONFIG_KEXEC here at all?

> >Ok, let's recap: so far, for your use case you need:
> >
> >CONFIG_MEMORY_HOTREMOVE
> >CONFIG_RANDOMIZE_BASE
> >and now
> >CONFIG_KEXEC
> >
> >So, you can clean up all that ifdeffery by defining a new config item
> >CONFIG_EARLY_PARSE_RSDP or so which depends on all those three items and
> >then you can do
> >
> >vmlinux-objs-$(CONFIG_EARLY_PARSE_RSDP) += $(obj)/acpitb.o
> >
> >and get rid of the most of the ifdeffery.

Regardless of CONFIG_KEXEC - you still need to define a CONFIG_ symbol
for your use case. We won't be parsing RSDP early on !MEMORY_HOTREMOVE
machines, which is the majority.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
