From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Wed, 31 Oct 2012 17:44:22 +0000
Message-ID: <20121031174422.GA19043@srcf.ucam.org>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
 <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
 <20121029174131.GC7580@srcf.ucam.org>
 <s5hobjia6vj.wl%tiwai@suse.de>
 <20121031173728.GA18615@srcf.ucam.org>
 <20121031174440.009af66f@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121031174440.009af66f@pyramind.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Takashi Iwai <tiwai@suse.de>, Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Wed, Oct 31, 2012 at 05:44:40PM +0000, Alan Cox wrote:
> > That does still leave me a little uneasy as far as the microcode 
> > licenses go. I don't know that we can distribute signed copies of some 
> > of them, and we obviously can't sign at the user end.
> 
> You seem to put them in signed rpm packages ?

That's not a modification of the files that say "You have permission to 
distribute unmodified versions of this file". If a lawyer says this is 
fine, I'm happy.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
