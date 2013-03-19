From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] x86/efi: pull NV+BS variables out before we exit boot
 services
Date: Tue, 19 Mar 2013 17:17:27 +0000
Message-ID: <1363713447.2377.60.camel@dabdike.int.hansenpartnership.com>
References: <1363596014.2412.8.camel@dabdike.int.hansenpartnership.com>
	 <20130319014850.GA28934@srcf.ucam.org>
	 <1363680885.2377.11.camel@dabdike.int.hansenpartnership.com>
	 <20130319163531.GA10879@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130319163531.GA10879@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-efi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 2013-03-19 at 16:35 +0000, Matthew Garrett wrote:
> On Tue, Mar 19, 2013 at 08:14:45AM +0000, James Bottomley wrote:
> 
> > Any security assumptions that rely on inability to read certain
> > information aren't really going to be that secure.  Inability to modify,
> > sure, but inability to read, not really.
> 
> Well, I guess that's public/private key cryptography screwed.

Well, OK, it's ex-BIOS writers we're dealing with, so I won't say no-one
would be stupid enough to come up with a security scheme embedding
Private Keys in BS+NV variables, but I would have thought the fact that
Linux would blow the lid off it might be a good incentive not to do it
and thus a plus point for this patch.

James
