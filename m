From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v8 0/3] x86/boot/KASLR: Parse ACPI table and limit kaslr
 in immovable memory
Date: Wed, 10 Oct 2018 11:19:23 +0200
Message-ID: <20181010091923.GC5533@zn.tnic>
References: <20181010084119.17539-1-fanc.fnst@cn.fujitsu.com>
 <20181010085920.GB5533@zn.tnic>
 <20181010090620.GF25297@MiWiFi-R3L-srv>
 <alpine.DEB.2.21.1810101113070.10278@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1810101113070.10278@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Baoquan He <bhe@redhat.com>, Chao Fan <fanc.fnst@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, rjw@rjwysocki.net, lenb@kernel.org, ard.biesheuvel@linaro.org, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com, Masayoshi Mizuma <msys.mizuma@gmail.com>
List-Id: linux-efi@vger.kernel.org

On Wed, Oct 10, 2018 at 11:14:26AM +0200, Thomas Gleixner wrote:
> Yes, it's different, but if the SRAT information is available early, then
> the command line parameter can go away because then the required
> information for Masa's problem is available as well.

Exactly. And I'd prefer we delayed the command line parameter until we
figure out we really need it and not expose it to upstream and then
remove it shortly after.

So I'd suggest we move Masa's patches to a separate branch and not send
it up this round.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
