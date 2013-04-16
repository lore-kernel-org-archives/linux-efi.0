From: Joel Schopp <jschopp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: unusual uefi call/mapping problem
Date: Tue, 16 Apr 2013 16:31:17 -0500
Message-ID: <516DC325.6090604@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Leonidas da Silva Barbosa <leosilva-xuelUoVDAHHQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

I'm working on the Linux kernel implementation of an draft standard that 
has a uefi component.  The interesting part is that the uefi component 
isn't in the uefi runtime table, but instead has a physical address 
stored an ACPI table.  Other than not being in the runtime table it 
behaves exactly like the other runtime services.

After extracting the physical address of the UEFI service we can't 
successfully map it or call it.  I'm sure this is straightforward to 
somebody with experience in this area.  Here's a few of the things I've 
tried unsuccessfully, any pointers here would be appreciated.

1) Call the physical address
efi_call_phys_prelog();
efi_call_phys5(...);
efi_call_phys_epilog();

This generates some nasty scheduling while atomic errors

2) Various methods to map in the physical address into virtual address 
space and then call the virtual address.  All of these have failed.

3) I've started looking at adding an entry to the efi struct and a line 
to efi_enter_virtual_mode(...) with the new function name but haven't 
found the right spot to add an extra entry on to the mmap structure. 
Does this seem like a sane approach?

-Joel Schopp
