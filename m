From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [Bug Report] kdump crashes after latest EFI memblock changes on
 arm64 machines with large number of CPUs
Date: Tue, 6 Nov 2018 01:30:23 +0000
Message-ID: <20181106013022.GA27793@brain-police>
References: <CACi5LpOyy0YkhEzWWqt8hAQfKku2Vzp5+da_dGS23JMyHReNew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CACi5LpOyy0YkhEzWWqt8hAQfKku2Vzp5+da_dGS23JMyHReNew-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, kexec mailing list <kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Bhupesh SHARMA <bhupesh.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-arm-kernel <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Nov 02, 2018 at 02:44:10AM +0530, Bhupesh Sharma wrote:
> With the latest EFI changes for memblock reservation across kdump
> kernel from Ard (Commit 71e0940d52e107748b270213a01d3b1546657d74
> ["efi: honour memory reservations passed via a linux specific config
> table"]), we hit a panic while trying to boot the kdump kernel on
> machines which have large number of CPUs.
> 
> I have a arm64 board which has 224 CPUS:
> # lscpu
> <..snip..>
> CPU(s):              224
> On-line CPU(s) list: 0-223
> <..snip..>
> 
> Here are the crash logs in the kdump kernel on this machine:
> 
> [    0.000000] Unable to handle kernel paging request at virtual
> address ffff80003ffe0000
> val____)nt EL), IL ata abort info:
> [    0.or: Oops: 960000inted 4.18.0+ #3
> [    0.000000] pstate: 20400089 (nzCv daIf +PAN -UAO)
> [    0.000000] pc : __memcpy+0x110/0x180
> [    0.000000] lr : memblock_double_array+0x240/0x348
> [    0.000000] sp : ffff0000092efc80 x28: 00000000bffe0000
> [    0.000000] x27: 0000000000001800 x26: ffff000009d59000
> [    0.000000] x25: ffff80003ffe0000 x24: 0000000000000000
> [    0.000000] x23: 0000000000010000 x22: ffff000009d594e8
> [    0.000000] x21: ffff000009d594f4 x20: ffff0000093c7268
> [    0.000000] x19: 0000000000000c00 x18: 0000000000000010
> [    0.000000] x17: 0000000000000000 x16: 0000000000000000
> [    0.000000] x15: ffffffffffffffff3: 0000000fc18d0000 x12: 0000000800000000
> [    0.000000] x11: 0000000000000018 x10: 00000000ddab9e18
> [    0.000000] x9 : 0000000800000000 x8 : 00000000000002c1
> [    0.000000] x7 : 0000000091b90000 x6 : ffff80003ffe0000
> [    0.000000] x5 : 0000000000000001 x4 : 0000000000000000
> [    0.000000] x3 : 0000000000000000 x2 : 0000000000000b80
> [    0.000000] x1 : ffff000009d59540 x0 : ffff80003ffe0000
> [    0.000000] Process swapper)
> [    0.000000] Call trace:
> [    0.000000]  __memcpy+0x110/0x180
> [    0.000000]  memblock_add_range+0x134/0x2e8
> [    0.000000]  memblock_reserve+0x70/0xb8
> [    0.000000]  memblock_alloc_base_nid+0x6c/0x88
> [    0.000000]  __memblock_alloc_base+0x3c/0x4c
> [    0.000000]  memblock_alloc_base+0x28/0x4c
> [    0.000000]  memblock_alloc+0x2c/0x38
> [    0.000000]  early_pgtable_alloc+0x20/0xb0

Hmm, so this seems to be the crux of the issue: early_pgtable_alloc() relies
on memblock to allocate page-table memory, but this can be called before the
linear mapping is up and running (or even as part of creating the linear
mapping itself!) so the use of __va in memblock_double_array() actually
returns an unmapped address.

So I guess we either need to implement early_pgtable_alloc() some other way
(how?) or get memblock_double_array() to use a fixmap if it's called too
early (yuck). Alternatively, would it be possible to postpone processing of
the EFI mem_reserve entries until after we've created the linear mapping?

Will
