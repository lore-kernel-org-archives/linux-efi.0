From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 25/27] Lock down /proc/kcore
Date: Mon, 23 Oct 2017 15:56:57 +0100
Message-ID: <22790.1508770617@warthog.procyon.org.uk>
References: <alpine.LFD.2.20.1710210609270.22771@t440> <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk> <150842482228.7923.9630520914833154257.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.20.1710210609270.22771@t440>
Content-ID: <22789.1508770617.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: James Morris <james.l.morris@oracle.com>
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

James Morris <james.l.morris@oracle.com> wrote:

> I have to wonder, though, after everything is locked down, how easy will 
> it be for new things to slip in which need to be included in the lockdown, 
> but are not.

That's always a possibility, and short of reviewing every change, particularly
in the drivers, I'm not sure how to prevent it.

David
