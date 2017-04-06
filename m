From: Oliver Neukum <oneukum@suse.com>
Subject: Re: [PATCH 11/24] uswsusp: Disable when the kernel is locked down
Date: Thu, 06 Apr 2017 08:39:52 +0200
Message-ID: <1491460792.1645.1.camel@suse.com>
References: <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk>
         <149142336965.5101.2946578135980499557.stgit@warthog.procyon.org.uk>
         <CAJZ5v0hp=GJtQ+YnNdaMw6rtbBzNyueY+iqjPkHLKp57t822ZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CAJZ5v0hp=GJtQ+YnNdaMw6rtbBzNyueY+iqjPkHLKp57t822ZQ@mail.gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
To: "Rafael J. Wysocki" <rafael@kernel.org>, David Howells <dhowells@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>, linux-efi@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux PM <linux-pm@vger.kernel.org>, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, matthew.garrett@nebula.com
List-Id: linux-efi@vger.kernel.org

Am Donnerstag, den 06.04.2017, 01:38 +0200 schrieb Rafael J. Wysocki:
> On Wed, Apr 5, 2017 at 10:16 PM, David Howells <dhowells@redhat.com> wrote:
> > 
> > From: Matthew Garrett <mjg59@srcf.ucam.org>
> > 
> > uswsusp allows a user process to dump and then restore kernel state, which
> > makes it possible to modify the running kernel.  Disable this if the kernel
> > is locked down.
> > 
> > Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
> > Signed-off-by: David Howells <dhowells@redhat.com>
> > cc: linux-pm@vger.kernel.org
> 
> You probably want to disable hibernation altogether in this case.

Your swap partition may be located on an NVDIMM or be encrypted.
Isn't this a bit overly drastic?

	Regards
		Oliver

