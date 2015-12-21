From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v10 1/1] efi: a misc char interface for user to update
 efi firmware
Date: Mon, 21 Dec 2015 18:37:15 +0100
Message-ID: <20151221173715.GE21582@pd.tnic>
References: <1450440782-5446-1-git-send-email-hock.leong.kweh@intel.com>
 <1450440782-5446-2-git-send-email-hock.leong.kweh@intel.com>
 <1450717451.8767.69.camel@nexus-software.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1450717451.8767.69.camel@nexus-software.ie>
Sender: linux-kernel-owner@vger.kernel.org
To: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Cc: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, Matt Fleming <matt@console-pimps.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ong Boon Leong <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Roy Franz <roy.franz@linaro.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Anvin H Peter <h.peter.anvin@intel.com>
List-Id: linux-efi@vger.kernel.org

On Mon, Dec 21, 2015 at 05:04:11PM +0000, Bryan O'Donoghue wrote:
> > This patch also export efi_capsule_supported() function symbol for
> > verifying the submitted capsule header in this kernel module.
> 
> 1. Should be a separate patch 
> 2. Suggested, rewording for that patch log
> 
> 2/2 Title
> This patch exports efi_capsule_supported to enable verification of the
> capsule header.
> 
> That said - who is the user of this symbol ? Why is it needed ? Anyway
> please consider splitting and rewording.

Huh?

I still don't really see the reasoning for splitting out the export.

When you do the export and use it in a single patch it is *obvious* why
it is being exported.

And there's no need to mention in the commit message that you're
exporting a symbol. People export symbols all the time.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
