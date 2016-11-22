From: Borislav Petkov <bp@alien8.de>
Subject: Re: [RFC PATCH v3 13/20] x86: DMA support for memory encryption
Date: Tue, 22 Nov 2016 12:38:59 +0100
Message-ID: <20161122113859.5dtlrfgizwpum6st@pd.tnic>
References: <20161110003426.3280.2999.stgit@tlendack-t1.amdoffice.net>
 <20161110003723.3280.62636.stgit@tlendack-t1.amdoffice.net>
 <20161115171443-mutt-send-email-mst@kernel.org>
 <4d97f998-5835-f4e0-9840-7f7979251275@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4d97f998-5835-f4e0-9840-7f7979251275@amd.com>
Sender: linux-doc-owner@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Rik van Riel <riel@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Joerg Roedel <joro@8bytes.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Larry Woodman <lwoodman@redhat.com>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 15, 2016 at 12:29:35PM -0600, Tom Lendacky wrote:
> > Makes sense, but I think at least a dmesg warning here
> > might be a good idea.
> 
> Good idea.  Should it be a warning when it is first being set up or
> a warning the first time the bounce buffers need to be used.  Or maybe
> both?

Ok, let me put my user hat on...

(... puts a felt hat ...)

so what am I supposed to do about this as a user? Go and physically
remove those devices because I want to enable SME?!

IMO, the only thing we should do is issue a *single* warning -
pr_warn_once - along the lines of:

"... devices present which due to SME will use bounce buffers and will
cause their speed to diminish. Boot with sme=debug to see full info".

And then sme=debug will dump the whole gory details. I don't think
screaming for each device is going to change anything in many cases.
99% of people don't care - they just want shit to work.

> > A boot flag that says "don't enable devices that don't support
> > encryption" might be a good idea, too, since most people
> > don't read dmesg output and won't notice the message.
> 
> I'll look into this. It might be something that can be checked as
> part of the device setting its DMA mask or the first time a DMA
> API is used if the device doesn't explicitly set its mask.

Still with my user hat on, what would be the purpose of such an option?

We already use bounce buffers so those devices do support encryption,
albeit slower.

felt hat is confused.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
