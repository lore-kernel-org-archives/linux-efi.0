From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Subject: Re: [PATCH v11 3/5] x86/boot: Add get_acpi_rsdp() to parse RSDP in
 cmdlien from kexec
Date: Tue, 13 Nov 2018 15:06:16 -0500
Message-ID: <20181113200615.7dypqvhimxzlloek@gabell>
References: <20181112094645.4879-1-fanc.fnst@cn.fujitsu.com>
 <20181112094645.4879-4-fanc.fnst@cn.fujitsu.com>
 <20181112174343.mvjri2okwboew2nw@gabell>
 <20181113021218.GD7453@localhost.localdomain>
 <20181113161111.6jwm36fpxk5xjtn5@gabell>
 <20181113175413.GL10502@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181113175413.GL10502@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Chao Fan <fanc.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, bhe@redhat.com, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 13, 2018 at 06:54:13PM +0100, Borislav Petkov wrote:
> On Tue, Nov 13, 2018 at 11:11:11AM -0500, Masayoshi Mizuma wrote:
> > I think it's not very good idea to use kstrtoull() in
> > arch/x86/boot/compressed/* because some tricks are needed to
> > use the function, looks like Chao is trying...
> 
> Ok, I had a look at the patch. And frankly, I don't see anything wrong
> with the aspect of using kstrtoull() in the compressed stage too and
> getting rid of simple_strtoull().
> 
> So what are your reservations?

Thank you for your checking.
I just felt the BOOT_STRING thing in lib/kstrtox.c confuses...
I'm OK for now if it's applied your below comment.

> > @@ -126,6 +126,8 @@ int kstrtoull(const char *s, unsigned int base, unsigned long long *res)
> >  }
> >  EXPORT_SYMBOL(kstrtoull);
> 
> This needs a comment to explain what is that guard used for.

Thanks,
Masa
