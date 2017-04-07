From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 09/24] kexec_file: Disable at runtime if securelevel has
 been set
Date: Fri, 07 Apr 2017 03:46:20 -0400
Message-ID: <1491551180.4184.50.camel@linux.vnet.ibm.com>
References: <1491536950.4184.10.camel@linux.vnet.ibm.com>
         <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk>
         <149142335441.5101.2294976563846442575.stgit@warthog.procyon.org.uk>
         <20170407030545.GA4296@dhcp-128-65.nay.redhat.com>
         <21572.1491548994@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <21572.1491548994@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Dave Young <dyoung@redhat.com>, linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>, linux-efi@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, Chun-Yi Lee <jlee@suse.com>, gregkh@linuxfoundation.org, kexec@lists.infradead.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, matthew.garrett@nebula.com
List-Id: linux-efi@vger.kernel.org

On Fri, 2017-04-07 at 08:09 +0100, David Howells wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > > > +	if (!IS_ENABLED(CONFIG_KEXEC_VERIFY_SIG) && kernel_is_locked_down())
> > > > +		return -EPERM;
> > > > +
> > > >  
> > 
> > IMA can be used to verify file signatures too, based on the LSM hooks
> > in  kernel_read_file_from_fd().  CONFIG_KEXEC_VERIFY_SIG should not be
> > required.
> 
> Okay, fair enough.  I can stick in an OR with an IS_ENABLED on some IMA
> symbol.  CONFIG_IMA_KEXEC maybe?  And also require IMA be enabled?

Not quite, since as Dave pointed out, IMA is policy driven.  As a
policy is installed, we could set a flag.

Mimi
