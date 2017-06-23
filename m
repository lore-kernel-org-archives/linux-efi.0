From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v7 33/36] x86/mm: Use proper encryption attributes with
 /dev/mem
Date: Fri, 23 Jun 2017 11:32:36 +0200
Message-ID: <20170623093236.ei7z2zmc6vjq5lod@pd.tnic>
References: <20170616184947.18967.84890.stgit@tlendack-t1.amdoffice.net>
 <20170616185607.18967.51412.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170616185607.18967.51412.stgit@tlendack-t1.amdoffice.net>
Sender: linux-arch-owner@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, xen-devel@lists.xen.org, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Brijesh Singh <brijesh.singh@amd.com>, Toshimitsu Kani <toshi.kani@hpe.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, Alexander Potapenko <glider@google.com>, "H. Peter Anvin" <hpa@zytor.com>, Larry Woodman <lwoodman@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Joerg Roedel <joro@8bytes.org>, "Michael S. Tsirkin" <mst@redhat.com>, Ingo Molnar <mingo@redhat.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Dave Young <dy>
List-Id: linux-efi@vger.kernel.org

On Fri, Jun 16, 2017 at 01:56:07PM -0500, Tom Lendacky wrote:
> When accessing memory using /dev/mem (or /dev/kmem) use the proper
> encryption attributes when mapping the memory.
> 
> To insure the proper attributes are applied when reading or writing
> /dev/mem, update the xlate_dev_mem_ptr() function to use memremap()
> which will essentially perform the same steps of applying __va for
> RAM or using ioremap() for if not RAM.
> 
> To insure the proper attributes are applied when mmapping /dev/mem,
> update the phys_mem_access_prot() to call phys_mem_access_encrypted(),
> a new function which will check if the memory should be mapped encrypted
> or not. If it is not to be mapped encrypted then the VMA protection
> value is updated to remove the encryption bit.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/include/asm/io.h |    3 +++
>  arch/x86/mm/ioremap.c     |   18 +++++++++---------
>  arch/x86/mm/pat.c         |    3 +++
>  3 files changed, 15 insertions(+), 9 deletions(-)

Reviewed-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
