From: James Morris <jmorris@namei.org>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Sat, 31 Mar 2018 11:46:10 +1100 (AEDT)
Message-ID: <alpine.LRH.2.21.1803311145180.7769@namei.org>
References: <4136.1522452584@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4136.1522452584@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, mjg59@google.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com, linux-man@vger.kernel.org, jlee@suse.com, linux-security-module@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Sat, 31 Mar 2018, David Howells wrote:

> Date: Thu, 26 Oct 2017 17:37:38 +0100
> 
> Hi James,
> 
> Can you pull this patchset into security/next please?  It has been in
> linux-next since the beginning of March.
> 
> It adds kernel lockdown support for EFI secure boot.

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git 
next-lockdown and next-testing

Are there any known coverage gaps now?



-- 
James Morris
<jmorris@namei.org>
