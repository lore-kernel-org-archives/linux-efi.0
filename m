From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 6/6] Documentation/x86: Update EFI memory region
 description
Date: Fri, 13 Nov 2015 09:29:06 +0000
Message-ID: <20151113092906.GD2716@codeblueprint.co.uk>
References: <1447342823-3612-1-git-send-email-matt@codeblueprint.co.uk>
 <1447342823-3612-7-git-send-email-matt@codeblueprint.co.uk>
 <20151113092210.GB19922@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151113092210.GB19922@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Jones <davej@codemonkey.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Denys Vlasenko <dvlasenk@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>
List-Id: linux-efi@vger.kernel.org

On Fri, 13 Nov, at 10:22:10AM, Ingo Molnar wrote:
> 
> * Matt Fleming <matt@codeblueprint.co.uk> wrote:
> 
> > +We map EFI runtime services in the efi_pgd PGD in the virtual range of
> > +64Gb (arbitrarily set, can be raised if needed). The mappings are not
> > +part of any other kernel PGD and are only available during EFI runtime
> > +calls.
> 
> Is that virtual address range 0-64Gb, i.e.:
> 
> 	0x00000000.00000000 - 0x00000010.00000000
> 
> or is it somewhere else?

You've snipped the patch hunk that gives the address range used,

diff --git a/Documentation/x86/x86_64/mm.txt
b/Documentation/x86/x86_64/mm.txt
index 05712ac83e38..a9885bb1ac22 100644
--- a/Documentation/x86/x86_64/mm.txt
+++ b/Documentation/x86/x86_64/mm.txt
@@ -16,6 +16,8 @@ ffffec0000000000 - fffffc0000000000 (=44 bits) kasan
shadow memory (16TB)
 ... unused hole ...
 ffffff0000000000 - ffffff7fffffffff (=39 bits) %esp fixup stacks
 ... unused hole ...
+ffffffef00000000 - ffffffff00000000 (=64 GB) EFI region mapping space
+... unused hole ...
 ffffffff80000000 - ffffffffa0000000 (=512 MB)  kernel text mapping,
from phys 0
 ffffffffa0000000 - ffffffffff5fffff (=1525 MB) module mapping space
 ffffffffff600000 - ffffffffffdfffff (=8 MB) vsyscalls
