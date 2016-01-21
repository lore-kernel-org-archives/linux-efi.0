From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH v10 1/1] efi: a misc char interface for user to update
 efi firmware
Date: Thu, 21 Jan 2016 12:35:47 +0000
Message-ID: <20160121123547.GC2510@codeblueprint.co.uk>
References: <1450440782-5446-1-git-send-email-hock.leong.kweh@intel.com>
 <1450440782-5446-2-git-send-email-hock.leong.kweh@intel.com>
 <1450717451.8767.69.camel@nexus-software.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1450717451.8767.69.camel@nexus-software.ie>
Sender: linux-kernel-owner@vger.kernel.org
To: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Cc: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ong Boon Leong <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Roy Franz <roy.franz@linaro.org>, Borislav Petkov <bp@alien8.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Anvin H Peter <h.peter.anvin@intel.com>
List-Id: linux-efi@vger.kernel.org

On Mon, 21 Dec, at 05:04:11PM, Bryan O'Donoghue wrote:
> > +static int efi_capsule_open(struct inode *inode, struct file *file)
> > +{
> > +	struct capsule_info *cap_info;
> > +
> > +	cap_info = kzalloc(sizeof(*cap_info), GFP_KERNEL);
> > +	if (!cap_info)
> > +		return -ENOMEM;
> > +
> > +	file->private_data = cap_info;
> > +
> > +	return 0;
> > +}
> 
> You have a memory leak here don't you ?
> 
> if I do 
> for (i = 0; i < N; i++) {
> 	fd = open(/dev/your_node);
> 	close(fd);
> }
> 
> You'll leak that kzalloc...

Nope, it gets freed in efi_capsule_release(). Though the code does
leak cap_info->pages if a capsule is successfully submitted to the
firmware.
