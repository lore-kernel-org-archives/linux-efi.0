From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: ESRT failures ... was Re: [PATCH 04/11] efi: Add
 efi_memmap_init_late() for permanent EFI memmap
Date: Tue, 26 Jul 2016 15:26:14 +0100
Message-ID: <20160726142614.GE31759@codeblueprint.co.uk>
References: <57867F32.8040001@redhat.com>
 <20160721121136.GF26504@codeblueprint.co.uk>
 <5790DFD0.4020806@redhat.com>
 <20160722131101.GJ26504@codeblueprint.co.uk>
 <57922028.7070103@redhat.com>
 <20160725144431.GA31759@codeblueprint.co.uk>
 <57962C23.5090705@redhat.com>
 <20160725151344.GB31759@codeblueprint.co.uk>
 <57963289.2090805@redhat.com>
 <57974AA4.7090907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57974AA4.7090907-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Lenny Szubowicz <lszubowi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 26 Jul, at 07:33:56AM, Prarit Bhargava wrote:
> 
> I was ping'd by a Dell engineer who says that Dell is taking a look at this.
> Most likely a BIOS fix will be released.
> 
> ... I think that means I should drop the issue :)

It would be valuable if they could still provide details on the issue
though. Not everyone will upgrade their BIOS and it would be nice to
have things work out of the box for those machines currently sat on
shelves in warehouses, i.e. where a fixed BIOS cannot be installed
before the user receives it. 

Feel free to pull whoever pinged you into this thread.
