From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v8 1/3] x86/boot: Add acpitb.c to parse acpi tables
Date: Tue, 16 Oct 2018 14:40:36 +0200
Message-ID: <20181016124036.GG5212@zn.tnic>
References: <20181010084119.17539-1-fanc.fnst@cn.fujitsu.com>
 <20181010084119.17539-2-fanc.fnst@cn.fujitsu.com>
 <20181011105708.GB25435@zn.tnic>
 <20181016024844.GA12871@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181016024844.GA12871@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Chao Fan <fanc.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, bhe@redhat.com, rjw@rjwysocki.net, lenb@kernel.org, ard.biesheuvel@linaro.org, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Tue, Oct 16, 2018 at 10:48:44AM +0800, Chao Fan wrote:
> Sorry for disturbing you again, I want to make sure this detail with you.
> You mean that I need splite this as a function and put it to
> cmdline.c, right?

Extract that functionality into a generic helper so that
handle_mem_options() and your get_acpi_rsdp() can call it instead
of duplicating the code. Also, why aren't they both using
cmdline_find_option() directly?

If something's missing, extend cmdline_find_option() to serve your
purposes too instead of copying the same code.

Make more sense?

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
