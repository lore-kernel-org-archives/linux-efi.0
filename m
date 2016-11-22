From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/6] x86/efi: Allow invocation of arbitrary runtime
 services
Date: Tue, 22 Nov 2016 08:51:08 -0800
Message-ID: <1479833468.1942.15.camel@perches.com>
References: <1479831939.1942.13.camel@perches.com>
         <1479826691.1942.11.camel@perches.com> <20161122102018.GB1552@wunner.de>
         <20161117123731.GA11573@wunner.de>
         <147977469914.6360.17194649697208113702.stgit@warthog.procyon.org.uk>
         <27422.1479824220@warthog.procyon.org.uk>
         <24973.1479829961@warthog.procyon.org.uk>
         <26968.1479832829@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <26968.1479832829@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Lukas Wunner <lukas@wunner.de>, linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Tue, 2016-11-22 at 16:40 +0000, David Howells wrote:
> Joe Perches <joe@perches.com> wrote:
> 
> > Umm, no, that's not correct.
> > SHA-1 lengths of 12 are unique for quite awhile yet.
> > 
> > https://blog.cuviper.com/2013/11/10/how-short-can-git-abbreviate/
> 
> The article says:
> 
> 	1.9% at 12
> 
> which is for 3253824 objects (I get 1.86%).
> 
> However, that was three years ago, and we now have over five million objects,
> so the collision possibility is 4.5% now.
> 
> If we add another 2 million over the next three years, then the probability
> will be over 8% then.
> 
> I've attached my spreadsheet for you to have a look at.
> 
> > No.  Use --format=email as appropriate instead.
> 
> Fix checkpatch.  This is an entirely reasonable supposition.

No.  There's nothing to fix there IMO.
Of course you are welcome to submit patches.
