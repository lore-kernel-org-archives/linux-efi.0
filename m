From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v7 10/36] x86/mm: Provide general kernel support for
 memory encryption
Date: Wed, 21 Jun 2017 09:18:59 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1706210916590.2328@nanos>
References: <20170616184947.18967.84890.stgit@tlendack-t1.amdoffice.net> <20170616185140.18967.61905.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20170616185140.18967.61905.stgit@tlendack-t1.amdoffice.net>
Sender: linux-doc-owner@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, xen-devel@lists.xen.org, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Brijesh Singh <brijesh.singh@amd.com>, Toshimitsu Kani <toshi.kani@hpe.com>, =?ISO-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, Alexander Potapenko <glider@google.com>, "H. Peter Anvin" <hpa@zytor.com>, Larry Woodman <lwoodman@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Joerg Roedel <joro@8bytes.org>, "Michael S. Tsirkin" <mst@redhat.com>, Ingo Molnar <mingo@redhat.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Dave
List-Id: linux-efi@vger.kernel.org

On Fri, 16 Jun 2017, Tom Lendacky wrote:
>  
> +#ifndef pgprot_encrypted
> +#define pgprot_encrypted(prot)	(prot)
> +#endif
> +
> +#ifndef pgprot_decrypted

That looks wrong. It's not decrypted it's rather unencrypted, right?

Thanks,

	tglx
