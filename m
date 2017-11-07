From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 02/27] Add a SysRq option to lift kernel lockdown
Date: Tue, 07 Nov 2017 22:56:51 +0000
Message-ID: <32418.1510095411@warthog.procyon.org.uk>
References: <877ev2rnt1.fsf@linux.vnet.ibm.com> <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk> <150842464774.7923.7951986297563109339.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <877ev2rnt1.fsf@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org


Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com> wrote:

> On non-x86 platforms (tested on powerpc) this fails to build with:
> 
> security/lock_down.c: In function ‘lockdown_lift_sysrq’:
> security/lock_down.c:100:40: error: ‘LOCKDOWN_LIFT_KEY’ undeclared (first use in this function)
>    lockdown_lift_sysrq_op.help_msg[5] = LOCKDOWN_LIFT_KEY;
>                                         ^~~~~~~~~~~~~~~~~
> security/lock_down.c:100:40: note: each undeclared identifier is reported only once for each function it appears in

I've added an arch dependency in the Kconfig file in my local branch.  I'll
try to get it pushed again.

David
