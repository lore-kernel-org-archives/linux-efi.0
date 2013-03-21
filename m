From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH 01/12] Security: Add CAP_COMPROMISE_KERNEL
Date: Thu, 21 Mar 2013 12:58:04 +1100 (EST)
Message-ID: <alpine.LRH.2.02.1303211257420.9518@tundra.namei.org>
References: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com>  <alpine.LRH.2.02.1303191542200.30973@tundra.namei.org> <1363797717.2580.10.camel@falcor1.watson.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1363797717.2580.10.camel@falcor1.watson.ibm.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Wed, 20 Mar 2013, Mimi Zohar wrote:

> On Tue, 2013-03-19 at 15:47 +1100, James Morris wrote:
> > On Mon, 18 Mar 2013, Matthew Garrett wrote:
> > 
> > > This patch introduces CAP_COMPROMISE_KERNEL. 
> > 
> > I'd like to see this named CAP_MODIFY_KERNEL, which is more accurate and 
> > less emotive.  Otherwise I think core kernel developers will be scratching 
> > their head over where to sprinkle this.
> > 
> > Apart from that, I like the idea, especially when it's wired up to MAC 
> > security.
> 
> Matthrew, perhaps you could clarify whether this will be tied to MAC
> security.

All capabilities are, via LSM.


-- 
James Morris
<jmorris@namei.org>
