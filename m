From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: v4.4-rc8 based tip tree kernel hangs on boot.
Date: Thu, 14 Jan 2016 12:25:13 +0000
Message-ID: <20160114122513.GA3602@codeblueprint.co.uk>
References: <20160110192921.GD17012@linux.vnet.ibm.com>
 <20160111140140.GA2644@codeblueprint.co.uk>
 <20160112103043.GA5707@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160112103043.GA5707@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 12 Jan, at 11:30:44AM, Ingo Molnar wrote:
> 
> Srikar, could you please send the good and bad System.map files, so that we see 
> what the effects of the aligning were? The two interesting sha1's to test are:
> 
>   21cdb6b56843: first bad commit
>   6ffeba960734: last good commit (parent commit of 21cdb6b56843)

Srikar any update here? This issue is holding up the merging of all
new EFI material for v4.5.

I was unable to reproduce your issue locally, what machine are you
running? From the hang picture it looks like some IBM machine, but if
you could provide more details that'd be useful.
