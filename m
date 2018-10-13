From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Subject: Re: [PATCH v8 0/3] x86/boot/KASLR: Parse ACPI table and limit kaslr
 in immovable memory
Date: Sat, 13 Oct 2018 17:45:51 -0400
Message-ID: <20181013214550.ag5qzokhkrkwnzsy@gabell>
References: <20181010085920.GB5533@zn.tnic>
 <20181010090620.GF25297@MiWiFi-R3L-srv>
 <alpine.DEB.2.21.1810101113070.10278@nanos.tec.linutronix.de>
 <20181010091923.GC5533@zn.tnic>
 <20181010093057.GA22088@MiWiFi-R3L-srv>
 <20181010194443.sgdvplwdnltshwwi@gabell>
 <20181011002955.GJ25297@MiWiFi-R3L-srv>
 <20181011055154.GB6667@localhost.localdomain>
 <20181013201958.zfzv5ahhe3xz7bwi@gabell>
 <20181013203429.GE31650@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181013203429.GE31650@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Chao Fan <fanc.fnst@cn.fujitsu.com>, Baoquan He <bhe@redhat.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, rjw@rjwysocki.net, lenb@kernel.org, ard.biesheuvel@linaro.org, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Sat, Oct 13, 2018 at 10:34:29PM +0200, Borislav Petkov wrote:
> On Sat, Oct 13, 2018 at 04:19:59PM -0400, Masayoshi Mizuma wrote:
> > Baoquan and Chao, thank you for your comments!
> > 
> > Boris, the patches has been merged to linux-next.
> 
> First of all, please do not top-post.
> 
> Even if they're in linux-next, that doesn't mean they should go upstream
> while there are still issues to be hammered out.

Got it, thanks.

> 
> In this particular case, if Chao Fan's patchset shapes up in a decent
> form to be upstreamed, we don't need the cmdline parameter anymore, do
> we?
> 
> Because we'll have the SRAT parsing and proper KASLR limits ready and
> working automatically, I'd say.

Yes, but I think we need to arrange the Chao's SRAT parsing to be used
from kernel_randomize_memory() because Chao's approach needs the SRAT
parsing before extract kernel and the padding size calculation needs
the parsing in start_kernel(), so they are living in different life
cycle and space.

Thanks,
Masa
