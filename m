From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v6 26/34] iommu/amd: Allow the AMD IOMMU to work with
 memory encryption
Date: Mon, 19 Jun 2017 19:18:20 +0200
Message-ID: <20170619171820.tq4htttamb52pyx5@pd.tnic>
References: <20170607191309.28645.15241.stgit@tlendack-t1.amdoffice.net>
 <20170607191745.28645.81756.stgit@tlendack-t1.amdoffice.net>
 <20170614174208.p2yr5exs4b6pjxhf@pd.tnic>
 <0611d01a-19f8-d6ae-2682-932789855518@amd.com>
 <20170615094111.wga334kg2bhxqib3@pd.tnic>
 <921153f5-1528-31d8-b815-f0419e819aeb@amd.com>
 <20170615153322.nwylo3dzn4fdx6n6@pd.tnic>
 <3db2c52d-5e63-a1df-edd4-975bce7f29c2@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3db2c52d-5e63-a1df-edd4-975bce7f29c2@amd.com>
Sender: linux-doc-owner@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Rik van Riel <riel@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Toshimitsu Kani <toshi.kani@hpe.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, "Michael S. Tsirkin" <mst@redhat.com>, Joerg Roedel <joro@8bytes.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Larry Woodman <lwoodman@redhat.com>, Brijesh Singh <brijesh.singh@amd.com>, Ingo Molnar <mingo@redhat.com>, Andy
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 15, 2017 at 11:33:41AM -0500, Tom Lendacky wrote:
> Changing the signature back reverts to the original way, so this can be
> looked at separate from this patchset then.

Right, the patch which added the volatile thing was this one:

  4bf5beef578e ("iommu/amd: Don't put completion-wait semaphore on stack")

and the commit message doesn't say why the thing needs to be volatile at
all.

Joerg?

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
