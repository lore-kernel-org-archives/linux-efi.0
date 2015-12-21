From: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Subject: Re: [PATCH v10 1/1] efi: a misc char interface for user to update
 efi firmware
Date: Mon, 21 Dec 2015 17:45:59 +0000
Message-ID: <1450719959.17337.0.camel@nexus-software.ie>
References: <1450440782-5446-1-git-send-email-hock.leong.kweh@intel.com>
	 <1450440782-5446-2-git-send-email-hock.leong.kweh@intel.com>
	 <1450717451.8767.69.camel@nexus-software.ie>
	 <20151221173715.GE21582@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20151221173715.GE21582@pd.tnic>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, Matt Fleming <matt@console-pimps.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ong Boon Leong <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Roy Franz <roy.franz@linaro.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Anvin H Peter <h.peter.anvin@intel.com>
List-Id: linux-efi@vger.kernel.org

On Mon, 2015-12-21 at 18:37 +0100, Borislav Petkov wrote:
> On Mon, Dec 21, 2015 at 05:04:11PM +0000, Bryan O'Donoghue wrote:
> > > This patch also export efi_capsule_supported() function symbol
> > > for
> > > verifying the submitted capsule header in this kernel module.
> > 
> > 1. Should be a separate patch 
> > 2. Suggested, rewording for that patch log
> > 
> > 2/2 Title
> > This patch exports efi_capsule_supported to enable verification of
> > the
> > capsule header.
> > 
> > That said - who is the user of this symbol ? Why is it needed ?
> > Anyway
> > please consider splitting and rewording.
> 
> Huh?
> 
> I still don't really see the reasoning for splitting out the export.
> 
> When you do the export and use it in a single patch it is *obvious*
> why
> it is being exported.
> 
> And there's no need to mention in the commit message that you're
> exporting a symbol. People export symbols all the time.
> 

Yes - saw the export down the end of the patchset. Feel free to ignore
that comment.
