From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Wed, 31 Oct 2012 17:37:50 +0000
Message-ID: <20121031173750.GB18615@srcf.ucam.org>
References: <20121029174131.GC7580@srcf.ucam.org>
 <alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz>
 <CA+5PVA63EHiXbGAox+FmJPvztSj_i7QgnDG8vdj=p0xE+dqgGQ@mail.gmail.com>
 <20121031155503.1aaf4c93@pyramind.ukuu.org.uk>
 <alpine.LNX.2.00.1210311653080.12781@pobox.suse.cz>
 <20121031170334.59833fb1@pyramind.ukuu.org.uk>
 <20121031171048.GA17163@srcf.ucam.org>
 <20121031172121.14cc1215@pyramind.ukuu.org.uk>
 <20121031171743.GA17652@srcf.ucam.org>
 <20121031173919.4fc63ddd@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121031173919.4fc63ddd@pyramind.ukuu.org.uk>
Sender: linux-security-module-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jiri Kosina <jkosina@suse.cz>, Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Wed, Oct 31, 2012 at 05:39:19PM +0000, Alan Cox wrote:
> On Wed, 31 Oct 2012 17:17:43 +0000
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > By booting a signed kernel, not turning on swap and writing directly to 
> > the swap partition.
> 
> Ok so the actual problem is that you are signing kernels that allow the
> user to skip the S4 resume check ?

What S4 resume check?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
