From: Alex Thorlton <athorlton@sgi.com>
Subject: Re: [PATCH] Map in physical addresses in efi_map_region_fixed
Date: Wed, 10 Aug 2016 12:19:51 -0500
Message-ID: <20160810171951.GA214806@stormcage.americas.sgi.com>
References: <1470441575-96065-1-git-send-email-athorlton@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1470441575-96065-1-git-send-email-athorlton@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex Thorlton <athorlton@sgi.com>
Cc: linux-kernel@vger.kernel.org, Russ Anderson <rja@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>, Mike Travis <travis@sgi.com>, Matt Fleming <matt@codeblueprint.co.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Fri, Aug 05, 2016 at 06:59:35PM -0500, Alex Thorlton wrote:
> This is a simple change to add in the physical mappings as well as the
> virtual mappings in efi_map_region_fixed.  The motivation here is to
> get access to EFI runtime code that is only available via the 1:1
> mappings on a kexec'd kernel.
> 
> The added call is essentially the kexec analog of the first __map_region
> that Boris put in efi_map_region in commit d2f7cbe7b26a ("x86/efi:
> Runtime services virtual mapping").

Just wanted to ping and see if anybody has had a chance to look at this?
Also, linux-kernel looks broken today (latest e-mails on lkml look to be
from last night?) so I wanted to send something to see if it goes
through :)

- Alex
