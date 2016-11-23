From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 2/6] arm/efi: Allow invocation of arbitrary runtime services [ver #2]
Date: Wed, 23 Nov 2016 09:34:03 +0000
Message-ID: <5320.1479893643@warthog.procyon.org.uk>
References: <147986056324.13790.12670822944798392730.stgit@warthog.procyon.org.uk> <147986054870.13790.8640536414645705863.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <147986056324.13790.12670822944798392730.stgit@warthog.procyon.org.uk>
Content-ID: <5318.1479893643.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: lukas@wunner.de
Cc: dhowells@redhat.com, linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> +#define efi_call_runtime(f, ...)	sys_table_arg->runtime->f(__VA_ARGS__)

Turns out it's not that simple - of course.  runtime->get_variable is just a
void pointer.  The old arm stub was casting it by virtue of assignment to a
function pointer variable.

The x86_64 appears to be doing bypassing all the compile-time type checking by
passing the arguments through an ellipsis and then fixing up the argument list
in the ->call() function.

What I've changed the ARM and ARM64 things to is:

	#define efi_call_runtime(f, ...)	((efi_##f##_t *)sys_table_arg->runtime->f)(__VA_ARGS__)

David
