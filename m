From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 26/27] efi: Add an EFI_SECURE_BOOT flag to indicate secure boot mode
Date: Mon, 23 Oct 2017 15:58:23 +0100
Message-ID: <23162.1508770703@warthog.procyon.org.uk>
References: <alpine.LFD.2.20.1710210618180.22771@t440> <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk> <150842483172.7923.2791223614506312745.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.20.1710210618180.22771@t440>
Content-ID: <23161.1508770703.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: James Morris <james.l.morris@oracle.com>
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

James Morris <james.l.morris@oracle.com> wrote:

> > +		default:
> > +			pr_info("Secure boot could not be determined\n");
> 
> Perhaps make this pr_warning and include the unknown mode value?

Done.

David
