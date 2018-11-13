From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Subject: Re: [PATCH v11 3/5] x86/boot: Add get_acpi_rsdp() to parse RSDP in
 cmdlien from kexec
Date: Tue, 13 Nov 2018 11:11:11 -0500
Message-ID: <20181113161111.6jwm36fpxk5xjtn5@gabell>
References: <20181112094645.4879-1-fanc.fnst@cn.fujitsu.com>
 <20181112094645.4879-4-fanc.fnst@cn.fujitsu.com>
 <20181112174343.mvjri2okwboew2nw@gabell>
 <20181113021218.GD7453@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181113021218.GD7453@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Chao Fan <fanc.fnst@cn.fujitsu.com>, bp@alien8.de
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, bhe@redhat.com, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

Hi Chao and Boris,

On Tue, Nov 13, 2018 at 10:12:18AM +0800, Chao Fan wrote:
> On Mon, Nov 12, 2018 at 12:43:44PM -0500, Masayoshi Mizuma wrote:
> >How about the following get_acpi_rsdp()...? It doesn't use kstrtoull().
> >
> >static void get_acpi_rsdp(acpi_physical_address *rsdp_addr)
> >{
> >#ifdef CONFIG_KEXEC
> >        unsigned long addr;
> >        char val[32];
> >
> >        if (cmdline_find_option("acpi_rsdp", val, sizeof(val)) > 0) {
> >                char *e;
> >
> >                if (!strncmp(val, "0x", 2)) {
> >                        addr = simple_strtoull(val + 2, &e, 16);
> >                        if ((addr == 0) || ((val + 2) == e))
> >                                return;
> >                        *rsdp_addr = (acpi_physical_address)addr;
> >                }
> >        }
> >#endif
> >}
> 
> Thanks for the suggestion.
> I used this function. In the old version, Boris said simple_strtoull()
> is the old function and told me use the new kstrtoull().

I think it's not very good idea to use kstrtoull() in
arch/x86/boot/compressed/* because some tricks are needed to
use the function, looks like Chao is trying...
It is the simple way here to use simple_strtoull() defined
in arch/x86/boot/boot.h, I think.

I know checkpatch.pl says an warning about simple_strtoull(),
however, I believe the warning is for simple_strtoull() defined
in lib/vsprintf.c.

Thanks,
Masa
