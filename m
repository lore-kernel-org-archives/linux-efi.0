From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v8 0/3] x86/boot/KASLR: Parse ACPI table and limit kaslr
 in immovable memory
Date: Wed, 10 Oct 2018 11:14:26 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1810101113070.10278@nanos.tec.linutronix.de>
References: <20181010084119.17539-1-fanc.fnst@cn.fujitsu.com> <20181010085920.GB5533@zn.tnic> <20181010090620.GF25297@MiWiFi-R3L-srv>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181010090620.GF25297@MiWiFi-R3L-srv>
Sender: linux-kernel-owner@vger.kernel.org
To: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>, Chao Fan <fanc.fnst@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, rjw@rjwysocki.net, lenb@kernel.org, ard.biesheuvel@linaro.org, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com, Masayoshi Mizuma <msys.mizuma@gmail.com>
List-Id: linux-efi@vger.kernel.org

On Wed, 10 Oct 2018, Baoquan He wrote:

> Hi Boris,
> 
> On 10/10/18 at 10:59am, Borislav Petkov wrote:
> > ... and we just picked up
> > 
> > https://lkml.kernel.org/r/20181001140843.26137-1-msys.mizuma@gmail.com
> > 
> > and without having looked at the rest of your stuff, if people accept
> > your solution, we don't need the silly parameter anymore, right?
> > 
> > Which means, we should not rush the whole thing yet until the whole
> > KASLR vs movable memory gets solved properly.
> 
> Masa's patches solves the problem in memory region KASLR which later hot
> added memory may be big than the default padding 10 TB.
> 
> Chao's patches is trying to fix a conflict between 'movable_node' and
> kernel text KASLR. If 'movable_node' specified, we rely on SRAT to get
> which memory region is movable or immovable, and movable region can be
> hot removed. But if kernel is randomized into movable memory, it can't
> be hot removed any more, this is a regression after KASLR introduced.
> So this is a different issue than Masa's.

Yes, it's different, but if the SRAT information is available early, then
the command line parameter can go away because then the required
information for Masa's problem is available as well.

Thanks,

	tglx
