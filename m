From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [RFC PATCH v4 26/28] x86: Allow kexec to be used with SME
Date: Fri, 17 Feb 2017 10:57:56 -0500
Message-ID: <20170217155756.GJ30272@char.us.ORACLE.com>
References: <20170216154158.19244.66630.stgit@tlendack-t1.amdoffice.net>
 <20170216154755.19244.51276.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170216154755.19244.51276.stgit@tlendack-t1.amdoffice.net>
Sender: owner-linux-mm@kvack.org
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Rik van Riel <riel@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Toshimitsu Kani <toshi.kani@hpe.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, "Michael S. Tsirkin" <mst@redhat.com>, Joerg Roedel <joro@8bytes.org>, Paolo Bonzini <pbonzini@redhat.com>, Brijesh Singh <brijesh.singh@amd.com>, Ingo Molnar <mingo@redhat.com>, Alexander Potapenko <glider@google.com>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>
List-Id: linux-efi@vger.kernel.org

On Thu, Feb 16, 2017 at 09:47:55AM -0600, Tom Lendacky wrote:
> Provide support so that kexec can be used to boot a kernel when SME is
> enabled.

Is the point of kexec and kdump to ehh, dump memory ? But if the
rest of the memory is encrypted you won't get much, will you?

Would it make sense to include some printk to the user if they
are setting up kdump that they won't get anything out of it?

Thanks.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
