From: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 09/24] kexec_file: Disable at runtime if securelevel has
 been set
Date: Tue, 02 May 2017 15:01:22 -0400
Message-ID: <1493751682.3680.11.camel@linux.vnet.ibm.com>
References: <1491568577.4184.97.camel@linux.vnet.ibm.com>
         <1491551180.4184.50.camel@linux.vnet.ibm.com>
         <1491536950.4184.10.camel@linux.vnet.ibm.com>
         <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk>
         <149142335441.5101.2294976563846442575.stgit@warthog.procyon.org.uk>
         <20170407030545.GA4296@dhcp-128-65.nay.redhat.com>
         <21572.1491548994@warthog.procyon.org.uk>
         <27362.1491556638@warthog.procyon.org.uk>
         <13679.1491830392@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <13679.1491830392-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, Chun-Yi Lee <jlee-IBi9RG/b67k@public.gmane.org>, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi David,

On Mon, 2017-04-10 at 14:19 +0100, David Howells wrote:
> Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> 
> > From an IMA perspective, either a file hash or signature are valid,
> > but for this usage it must be a signature.
> 
> Not necessarily.  If IMA can guarantee that a module is the same based on its
> hash rather than on a key, I would've thought that should be fine.

File hashes can be modified on the running system, so they're normally
used, in conjunction with EVM, to detect off line modification of
mutable files and prevent their usage.

These patches https://lkml.org/lkml/2017/5/2/465 should provide some
of the missing functionality.

Mimi
