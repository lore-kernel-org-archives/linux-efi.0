From: Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 00/12] One more attempt at useful kernel lockdown
Date: Mon,  9 Sep 2013 11:49:34 -0400
Message-ID: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: keescook@chromium.org, gregkh@linuxfoundation.org, hpa@zytor.com, linux-efi@vger.kernel.org, jmorris@namei.org, linux-security-module@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Some use cases require the ability to ensure that anything running in ring 0
is trusted code. We have support for signing the kernel and kernel modules,
but there's still a range of exported kernel interfaces that make it easy to
modify the running kernel. Previous attempts to implement a generic interface
to restrict this have included a new capability (breaks existing userspace)
and tying it to a requirement for signed modules (breaks assumptions in
certain situations where userspace is already running with restricted
privileges).

So, this is my final attempt at providing the functionality I'm interested
in without inherently tying it to Secure Boot. There's strong parallels
between the functionality that I'm interested in and the BSD securelevel
interface, so here's a trivial implementation. 
