From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v7 08/36] x86/mm: Add support to enable SME in early boot
 processing
Date: Wed, 21 Jun 2017 20:52:47 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1706212051120.2152@nanos>
References: <20170616184947.18967.84890.stgit@tlendack-t1.amdoffice.net> <20170616185115.18967.79622.stgit@tlendack-t1.amdoffice.net> <alpine.DEB.2.20.1706202259290.2157@nanos> <8d3c215f-cdad-5554-6e9c-5598e1081850@amd.com> <alpine.DEB.2.20.1706211720060.2328@nanos>
 <fc697503-ec54-f481-36b3-3d5bf63aaaee@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <fc697503-ec54-f481-36b3-3d5bf63aaaee@amd.com>
Sender: linux-doc-owner@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, xen-devel@lists.xen.org, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Brijesh Singh <brijesh.singh@amd.com>, Toshimitsu Kani <toshi.kani@hpe.com>, =?ISO-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, Alexander Potapenko <glider@google.com>, "H. Peter Anvin" <hpa@zytor.com>, Larry Woodman <lwoodman@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Joerg Roedel <joro@8bytes.org>, "Michael S. Tsirkin" <mst@redhat.com>, Ingo Molnar <mingo@redhat.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Dave
List-Id: linux-efi@vger.kernel.org

On Wed, 21 Jun 2017, Tom Lendacky wrote:
> On 6/21/2017 10:38 AM, Thomas Gleixner wrote:
> > 	/*
> > 	 * Sanitize CPU configuration and retrieve the modifier
> > 	 * for the initial pgdir entry which will be programmed
> > 	 * into CR3. Depends on enabled SME encryption, normally 0.
> > 	 */
> > 	call __startup_secondary_64
> > 
> >          addq    $(init_top_pgt - __START_KERNEL_map), %rax
> > 
> > You can hide that stuff in C-code nicely without adding any cruft to the
> > ASM code.
> > 
> 
> Moving the call to verify_cpu into the C-code might be quite a bit of
> change.  Currently, the verify_cpu code is included code and not a
> global function.

Ah. Ok. I missed that.

> I can still do the __startup_secondary_64() function and then look to
> incorporate verify_cpu into both __startup_64() and
> __startup_secondary_64() as a post-patch to this series.

Yes, just having __startup_secondary_64() for now and there the extra bits
for that encryption stuff is fine.

> At least the secondary path will have a base C routine to which
> modifications can be made in the future if needed.  How does that sound?

Sounds like a plan.
