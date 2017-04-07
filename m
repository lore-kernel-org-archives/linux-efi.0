From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 09/24] kexec_file: Disable at runtime if securelevel has been set
Date: Fri, 07 Apr 2017 08:07:55 +0100
Message-ID: <21418.1491548875@warthog.procyon.org.uk>
References: <20170407061935.GB10100@dhcp-128-65.nay.redhat.com> <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk> <149142335441.5101.2294976563846442575.stgit@warthog.procyon.org.uk> <20170407030545.GA4296@dhcp-128-65.nay.redhat.com> <1491536950.4184.10.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170407061935.GB10100@dhcp-128-65.nay.redhat.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Dave Young <dyoung@redhat.com>
Cc: dhowells@redhat.com, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>, linux-efi@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, Chun-Yi Lee <jlee@suse.com>, gregkh@linuxfoundation.org, kexec@lists.infradead.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, matthew.garrett@nebula.com
List-Id: linux-efi@vger.kernel.org

Dave Young <dyoung@redhat.com> wrote:

> > > > +	/* Don't permit images to be loaded into trusted kernels if we're not
> > > > +	 * going to verify the signature on them
> > > > +	 */
> > > > +	if (!IS_ENABLED(CONFIG_KEXEC_VERIFY_SIG) && kernel_is_locked_down())
> > > > +		return -EPERM;
> > > > +
> > > >  
> > 
> > IMA can be used to verify file signatures too, based on the LSM hooks
> > in  kernel_read_file_from_fd().  CONFIG_KEXEC_VERIFY_SIG should not be
> > required.
> 
> Mimi, I remember we talked somthing before about the two signature 
> verification. One can change IMA policy in initramfs userspace,
> also there are kernel cmdline param to disable IMA, so it can break the
> lockdown? Suppose kexec boot with ima disabled cmdline param and then
> kexec reboot again..

I guess I should lock down the parameter to disable IMA too.

David
