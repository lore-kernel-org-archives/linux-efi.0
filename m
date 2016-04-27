From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC PATCH v1 00/18] x86: Secure Memory Encryption (AMD)
Date: Wed, 27 Apr 2016 17:47:57 +0200
Message-ID: <20160427154757.GB8501@amd>
References: <20160426225553.13567.19459.stgit@tlendack-t1.amdoffice.net>
 <20160322130058.GA16528@xo-6d-61-c0.localdomain>
 <20160427140520.GG21011@pd.tnic>
 <20160427143045.GA4718@amd>
 <20160427143951.GH21011@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20160427143951.GH21011@pd.tnic>
Sender: owner-linux-mm@kvack.org
To: Borislav Petkov <bp@alien8.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Joerg Roedel <joro@8bytes.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Thomas Gleixner <tglx@linutronix.de>, Dmitry Vyukov <dvyukov@google.com>
List-Id: linux-efi@vger.kernel.org

On Wed 2016-04-27 16:39:51, Borislav Petkov wrote:
> On Wed, Apr 27, 2016 at 04:30:45PM +0200, Pavel Machek wrote:
> > That does not answer the question. "Why would I want SME on my
> > system?".
> 
> Because your question wasn't formulated properly. Here's some text from
> the 0th mail which you could've found on your own:
> 
> "The following links provide additional detail:
> 
> AMD Memory Encryption whitepaper:
>    http://amd-dev.wpengine.netdna-cdn.com/wordpress/media/2013/12/AMD_Memory_Encryption_Whitepaper_v7-Public.pdf
> "


Unfortunately that document is marketing junk.

AFAICT:

SME can protect against cold boot attack and snooping at DRAM
level. That's pretty much it.

Does the AES encryption take the address as a parameter?

SEV may protect against passive attack on the VM. For active attack,
they claim it will "probably" crash the VM, but we already know that
is untrue, see the work on gaining root using rowhammer. In this case,
attacker can choose which address to damage and has precise control of
timing.

Best regards,
                                                                Pavel
								

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
