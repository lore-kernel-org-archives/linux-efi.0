From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC PATCH v1 02/18] x86: Secure Memory Encryption (SME) build
 enablement
Date: Wed, 27 Apr 2016 18:41:37 +0200
Message-ID: <20160427164137.GA11779@amd>
References: <20160426225553.13567.19459.stgit@tlendack-t1.amdoffice.net>
 <20160426225614.13567.47487.stgit@tlendack-t1.amdoffice.net>
 <20160322130150.GB16528@xo-6d-61-c0.localdomain>
 <5720D810.9060602@amd.com>
 <20160427153010.GA7861@amd>
 <20160427154140.GK21011@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160427154140.GK21011@pd.tnic>
Sender: linux-arch-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Joerg Roedel <joro@8bytes.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Thomas Gleixner <tglx@linutronix.de>, Dmitry Vyukov <dvyukov@google.com>
List-Id: linux-efi@vger.kernel.org

On Wed 2016-04-27 17:41:40, Borislav Petkov wrote:
> On Wed, Apr 27, 2016 at 05:30:10PM +0200, Pavel Machek wrote:
> > Doing it early will break bisect, right?
> 
> How exactly? Please do tell.

Hey look, SME slowed down 30% since being initially merged into
kernel!
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
