From: Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v6 26/34] iommu/amd: Allow the AMD IOMMU to work with
 memory encryption
Date: Wed, 21 Jun 2017 17:37:22 +0200
Message-ID: <20170621153721.GP30388@8bytes.org>
References: <20170607191309.28645.15241.stgit@tlendack-t1.amdoffice.net>
 <20170607191745.28645.81756.stgit@tlendack-t1.amdoffice.net>
 <20170614174208.p2yr5exs4b6pjxhf@pd.tnic>
 <0611d01a-19f8-d6ae-2682-932789855518@amd.com>
 <20170615094111.wga334kg2bhxqib3@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170615094111.wga334kg2bhxqib3@pd.tnic>
Sender: owner-linux-mm@kvack.org
To: Borislav Petkov <bp@alien8.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Rik van Riel <riel@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Toshimitsu Kani <toshi.kani@hpe.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, "Michael S. Tsirkin" <mst@redhat.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Larry Woodman <lwoodman@redhat.com>, Brijesh Singh <brijesh.singh@amd.com>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexand
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 15, 2017 at 11:41:12AM +0200, Borislav Petkov wrote:
> On Wed, Jun 14, 2017 at 03:40:28PM -0500, Tom Lendacky wrote:
> > > WARNING: Use of volatile is usually wrong: see Documentation/process/volatile-considered-harmful.rst
> > > #134: FILE: drivers/iommu/amd_iommu.c:866:
> > > +static void build_completion_wait(struct iommu_cmd *cmd, volatile u64 *sem)
> > > 
> > 
> > The semaphore area is written to by the device so the use of volatile is
> > appropriate in this case.
> 
> Do you mean this is like the last exception case in that document above:
> 
> "
>   - Pointers to data structures in coherent memory which might be modified
>     by I/O devices can, sometimes, legitimately be volatile.  A ring buffer
>     used by a network adapter, where that adapter changes pointers to
>     indicate which descriptors have been processed, is an example of this
>     type of situation."
> 
> ?

So currently (without this patch) the build_completion_wait function
does not take a volatile parameter, only wait_on_sem() does.

Wait_on_sem() needs it because its purpose is to poll a memory location
which is changed by the iommu-hardware when its done with command
processing.

But the 'volatile' in build_completion_wait() looks unnecessary, because
the function does not poll the memory location. It only uses the
pointer, converts it to a physical address and writes it to the command
to be queued.


Regards,

	Joerg

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
