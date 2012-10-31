From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Wed, 31 Oct 2012 17:45:20 +0000
Message-ID: <20121031174520.GB19043@srcf.ucam.org>
References: <CA+5PVA63EHiXbGAox+FmJPvztSj_i7QgnDG8vdj=p0xE+dqgGQ@mail.gmail.com>
 <20121031155503.1aaf4c93@pyramind.ukuu.org.uk>
 <alpine.LNX.2.00.1210311653080.12781@pobox.suse.cz>
 <20121031170334.59833fb1@pyramind.ukuu.org.uk>
 <20121031171048.GA17163@srcf.ucam.org>
 <20121031172121.14cc1215@pyramind.ukuu.org.uk>
 <20121031171743.GA17652@srcf.ucam.org>
 <20121031173919.4fc63ddd@pyramind.ukuu.org.uk>
 <20121031173750.GB18615@srcf.ucam.org>
 <20121031174919.51f1518d@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121031174919.51f1518d@pyramind.ukuu.org.uk>
Sender: linux-security-module-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jiri Kosina <jkosina@suse.cz>, Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Wed, Oct 31, 2012 at 05:49:19PM +0000, Alan Cox wrote:
> On Wed, 31 Oct 2012 17:37:50 +0000
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > What S4 resume check?
> 
> One you would add .. but no I'm wrong there - its a problem at the
> suspend point so you do need a signature for it. Oh well yet another
> reason it's nto useful.

Right. Hence the idea of a protected keystore at boot time. We can do 
this securely, but it does involve writing code.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
