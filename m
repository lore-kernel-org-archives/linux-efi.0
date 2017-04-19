From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v5 01/32] x86: Documentation for AMD Secure Memory
 Encryption (SME)
Date: Wed, 19 Apr 2017 17:38:19 +0200
Message-ID: <20170419153818.3pl3gkdpe42lve44@pd.tnic>
References: <20170418211612.10190.82788.stgit@tlendack-t1.amdoffice.net>
 <20170418211625.10190.52568.stgit@tlendack-t1.amdoffice.net>
 <20170419090224.frmv2jhwfwoxvdie@pd.tnic>
 <bbda868c-9b34-4404-f563-98b000124ac5@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bbda868c-9b34-4404-f563-98b000124ac5@amd.com>
Sender: linux-arch-owner@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Rik van Riel <riel@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Toshimitsu Kani <toshi.kani@hpe.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, "Michael S. Tsirkin" <mst@redhat.com>, Joerg Roedel <joro@8bytes.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Larry Woodman <lwoodman@redhat.com>, Brijesh Singh <brijesh.singh@amd.com>, Ingo Molnar <mingo@redhat.com>, Andy
List-Id: linux-efi@vger.kernel.org

On Wed, Apr 19, 2017 at 09:23:47AM -0500, Tom Lendacky wrote:
> Btw, I tried to update all the subjects and descriptions to be
> more descriptive but I'm sure there is still room for improvement
> so keep the comments on them coming.

No worries there :)

> Note, just because the bit is set in %cr3 doesn't mean the full
> hierarchy is encrypted. Each level in the hierarchy needs to have the
> encryption bit set. So, theoretically, you could have the encryption
> bit set in %cr3 so that the PGD is encrypted, but not set the encryption
> bit in the PGD entry for a PUD and so the PUD pointed to by that entry
> would not be encrypted.

Ha, that is a nice detail I didn't realize. You could add it to the text.

Thanks.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
